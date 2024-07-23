import 'package:aquaware/models/water_value.dart';

class WaterParameter {
  final String parameter;
  final List<WaterValue> values;

  WaterParameter({required this.parameter, required this.values});

  factory WaterParameter.fromJson(Map<String, dynamic> json) {
    var valuesList = json['values'] as List;
    List<WaterValue> values =
        valuesList.map((i) => WaterValue.fromJson(i)).toList();
    return WaterParameter(parameter: json['parameter'], values: values);
  }
}
