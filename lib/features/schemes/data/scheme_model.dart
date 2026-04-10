class SchemeModel {
  final String id;
  final String name;
  final int monthlyAmount;
  final int durationMonths;
  final int maturityAmount;

  const SchemeModel({
    required this.id,
    required this.name,
    required this.monthlyAmount,
    required this.durationMonths,
    required this.maturityAmount,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      id: json['id'].toString(),
      name: json['name'],
      monthlyAmount: json['monthlyAmount'],
      durationMonths: json['durationMonths'],
      maturityAmount: json['maturityAmount'],
    );
  }
}