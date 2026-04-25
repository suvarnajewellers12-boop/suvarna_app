class RateModel {
  final String metal;
  final double rate;

  RateModel({
    required this.metal,
    required this.rate,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      metal: json["metal"] ?? "",
      rate: double.tryParse(json["rate"].toString()) ?? 0,
    );
  }
}