class SingleMeasurement {
  int temperature;
  int tds;
  double ph;

  SingleMeasurement(this.temperature, this.tds, this.ph);

  factory SingleMeasurement.fromJson(Map<String, dynamic> json) {
    return SingleMeasurement(
      json['field1'],
      json['field2'],
      json['field3'],
    );
  }
}
