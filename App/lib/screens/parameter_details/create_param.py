import os

# List of parameters
parameters = [
    'PH', 'Temperature', 'TDS', 'Oxygen', 'Ammonia', 'Nitrite', 'Nitrate', 'Phosphate',
    'Carbon Dioxide', 'Salinity', 'General Hardness', 'Carbonate Hardness', 'Copper',
    'Iron', 'Calcium', 'Magnesium', 'Potassium', 'Chlorine', 'Alkalinity',
    'Redox Potential', 'Silica', 'Boron', 'Strontium', 'Iodine', 'Molybdenum',
    'Sulfate', 'Organic Carbon', 'Turbidity', 'Conductivity', 'Total Organic Carbon',
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
            {parameter_class}DataScreen(),
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

class {class_name}DataScreen extends StatelessWidget {{
  @override
  Widget build(BuildContext context) {{
    return Center(
      child: Text('Data for {parameter}'),
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
