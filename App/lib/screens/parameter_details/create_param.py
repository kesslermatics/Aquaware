import os

# List of parameters
parameters = [
    'PH', 'Temperature', 'TDS', 'Oxygen', 'Ammonia', 'Nitrite', 'Nitrate', 'Phosphate',
    'Carbon Dioxide', 'Salinity', 'General Hardness', 'Carbonate Hardness', 'Copper',
    'Iron', 'Calcium', 'Magnesium', 'Potassium', 'Chlorine',
    'Redox Potential', 'Silica', 'Boron', 'Strontium', 'Iodine', 'Molybdenum',
    'Sulfate', 'Organic Carbon', 'Turbidity', 'Conductivity',
    'Suspended Solids', 'Fluoride', 'Bromine', 'Chloride'
]

# Directory to save the files
output_dir = '.'

# Template for the main screen Dart file content
main_screen_template = '''import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import '{parameter_snake_case}_data_screen.dart';
import '{parameter_snake_case}_knowledge_screen.dart';
import '{parameter_snake_case}_alerts_screen.dart';

class {class_name} extends StatelessWidget {{
  final int aquariumId;

  {class_name}({{required this.aquariumId}});

  @override
  Widget build(BuildContext context) {{
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('{parameter}'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {{
              Navigator.pop(context);
            }},
          ),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4,
            indicatorColor: ColorProvider.primary,
            labelColor: ColorProvider.textLight,
            unselectedLabelColor: ColorProvider.primary,
            tabs: [
              Tab(text: 'Data'),
              Tab(text: 'Knowledge'),
              Tab(text: 'Alerts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            {parameter_class}DataScreen(aquariumId: aquariumId),
            {parameter_class}KnowledgeScreen(),
            {parameter_class}AlertsScreen(),
          ],
        ),
      ),
    );
  }}
}}
'''

# Template for the data screen Dart file content
data_screen_template = '''import 'package:flutter/material.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:aquaware/models/water_value.dart';
import 'package:aquaware/services/color_provider.dart';

class {class_name}DataScreen extends StatefulWidget {{
  final int aquariumId;

  {class_name}DataScreen({{required this.aquariumId}});

  @override
  _{class_name}DataScreenState createState() => _{class_name}DataScreenState();
}}

class _{class_name}DataScreenState extends State<{class_name}DataScreen> {{
  late Future<List<WaterValue>> _futureWaterValues;
  final WaterParameterService _waterParameterService = WaterParameterService();

  @override
  void initState() {{
    super.initState();
    _futureWaterValues = _fetchWaterValues();
  }}

  Future<List<WaterValue>> _fetchWaterValues() async {{
    return await _waterParameterService.fetchSingleWaterParameter(
        widget.aquariumId, '{parameter}');
  }}

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: Text('{parameter} Data'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {{
            Navigator.pop(context);
          }},
        ),
      ),
      body: FutureBuilder<List<WaterValue>>(
        future: _futureWaterValues,
        builder: (context, snapshot) {{
          if (snapshot.connectionState == ConnectionState.waiting) {{
            return Center(child: CircularProgressIndicator());
          }} else if (snapshot.hasError) {{
            return Center(child: Text('Failed to load water values'));
          }} else if (!snapshot.hasData || snapshot.data!.isEmpty) {{
            return Center(child: Text('No water values found'));
          }} else {{
            return ListView.builder(
              padding: EdgeInsets.all(16.0),  
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {{
                final value = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('\${{value.value}} \${{value.unit}}'),
                    subtitle: Text('Measured at: \${{value.measuredAt}}'),
                  ),
                );
              }},
            );
          }}
        }},
      ),
    );
  }}
}}
'''

# Template for the knowledge screen Dart file content
knowledge_screen_template = '''import 'package:flutter/material.dart';

class {class_name}KnowledgeScreen extends StatelessWidget {{
  @override
  Widget build(BuildContext context) {{
    return Center(
      child: Text('Knowledge about {parameter}'),
    );
  }}
}}
'''

# Template for the alerts screen Dart file content
alerts_screen_template = '''import 'package:flutter/material.dart';

class {class_name}AlertsScreen extends StatelessWidget {{
  @override
  Widget build(BuildContext context) {{
    return Center(
      child: Text('Alerts for {parameter}'),
    );
  }}
}}
'''

# Ensure the output directory exists
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Create a Dart file for each parameter
for parameter in parameters:
    # Create a valid Dart class name
    class_name = parameter.replace(' ', '') + 'Screen'
    parameter_class = parameter.replace(' ', '')
    parameter_snake_case = parameter.lower().replace(' ', '_')
    
    # Generate the main screen file content
    main_content = main_screen_template.format(
        class_name=class_name,
        parameter=parameter,
        parameter_class=parameter_class,
        parameter_snake_case=parameter_snake_case
    )
    
    # Generate the data screen file content
    data_content = data_screen_template.format(
        class_name=parameter_class,
        parameter=parameter
    )
    
    # Generate the knowledge screen file content
    knowledge_content = knowledge_screen_template.format(
        class_name=parameter_class,
        parameter=parameter
    )
    
    # Generate the alerts screen file content
    alerts_content = alerts_screen_template.format(
        class_name=parameter_class,
        parameter=parameter
    )
    
    # Directory path for the parameter
    parameter_dir = os.path.join(output_dir, parameter_snake_case)
    if not os.path.exists(parameter_dir):
        os.makedirs(parameter_dir)
    
    # Write the content to the respective files
    with open(os.path.join(parameter_dir, parameter_snake_case + '_screen.dart'), 'w') as file:
        file.write(main_content)
        
    with open(os.path.join(parameter_dir, parameter_snake_case + '_data_screen.dart'), 'w') as file:
        file.write(data_content)
        
    with open(os.path.join(parameter_dir, parameter_snake_case + '_knowledge_screen.dart'), 'w') as file:
        file.write(knowledge_content)
        
    with open(os.path.join(parameter_dir, parameter_snake_case + '_alerts_screen.dart'), 'w') as file:
        file.write(alerts_content)

print('Files generated successfully.')
