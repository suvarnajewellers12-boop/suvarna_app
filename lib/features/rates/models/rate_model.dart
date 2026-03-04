class RateModel {
  final String label;
  final double rate;
  final double change;
  final String unit;
  final String purity;
  final double per10g;
  final double per100g;
  final double perTola;
  final String lastUpdated;

  RateModel({
    required this.label,
    required this.rate,
    required this.change,
    required this.unit,
    required this.purity,
    required this.per10g,
    required this.per100g,
    required this.perTola,
    required this.lastUpdated,
  });
}