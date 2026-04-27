class CouponModel {
  final String id;
  final String code;
  final bool isUsed;
  final bool isActive;
  final double totalCashValue;
  final double totalWeightGrams;
  final String schemeName;
  final bool isWeightBased;
  final int durationMonths;
  final double monthlyAmount;
  final double totalPaid;
  final double accumulatedGrams;
  final DateTime createdAt;
  final DateTime? usedAt;

  CouponModel({
    required this.id,
    required this.code,
    required this.isUsed,
    required this.isActive,
    required this.totalCashValue,
    required this.totalWeightGrams,
    required this.schemeName,
    required this.isWeightBased,
    required this.durationMonths,
    required this.monthlyAmount,
    required this.totalPaid,
    required this.accumulatedGrams,
    required this.createdAt,
    this.usedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    final scheme = json["Scheme"] ?? {};
    final cs = json["CustomerScheme"] ?? {};

    return CouponModel(
      id: json["id"]?.toString() ?? "",
      code: json["code"]?.toString() ?? "",
      isUsed: json["isUsed"] == true,
      isActive: json["isActive"] == true,
      totalCashValue: double.tryParse(json["totalCashValue"].toString()) ?? 0,
      totalWeightGrams: double.tryParse(json["totalWeightGrams"].toString()) ?? 0,
      schemeName: scheme["name"]?.toString() ?? "Scheme",
      isWeightBased: scheme["isWeightBased"] == true,
      durationMonths: int.tryParse(scheme["durationMonths"].toString()) ?? 0,
      monthlyAmount: double.tryParse(scheme["monthlyAmount"].toString()) ?? 0,
      totalPaid: double.tryParse(cs["totalPaid"].toString()) ?? 0,
      accumulatedGrams: double.tryParse(cs["accumulatedGrams"].toString()) ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? "") ?? DateTime.now(),
      usedAt: json["usedAt"] != null
          ? DateTime.tryParse(json["usedAt"].toString())
          : null,
    );
  }
}