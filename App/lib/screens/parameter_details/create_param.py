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

# Template for the Dart file content
template = '''import 'package:flutter/material.dart';

class {class_name} extends StatelessWidget {{
  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: Text('{parameter}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {{
            Navigator.pop(context);
          }},
        ),
      ),
      body: Center(
        child: Text('Detailed information about {parameter}'),
      ),
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
    
    # Generate the file content
    content = template.format(class_name=class_name, parameter=parameter)
    
    # Generate the file name
    file_name = parameter.lower().replace(' ', '_') + '_screen.dart'
    file_path = os.path.join(output_dir, file_name)
    
    # Write the content to the file
    with open(file_path, 'w') as file:
        file.write(content)

print('Files generated successfully.')
