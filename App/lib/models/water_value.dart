class WaterValue {
  final DateTime measuredAt;
  final double value;
  final String unit;

  WaterValue(
      {required this.measuredAt, required this.value, required this.unit});

  factory WaterValue.fromJson(Map<String, dynamic> json) {
    return WaterValue(
      measuredAt: DateTime.parse(json['measured_at']).toLocal(),
      value: json['value'],
      unit: json['unit'],
    );
  }
}
