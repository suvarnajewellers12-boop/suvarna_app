class EnrolledScheme {
  final String id;
  final String schemeId;
  final String name;
  final int totalAmount;
  final int amountPaid;
  final int amountBalance;
  final int monthsPaid;
  final int totalMonths;
  final String lastPaymentDate;
  final String nextDueDate;
  final bool isWeightBased;
  final double accumulatedGrams;
  final int monthlyAmount;
  final double lastPaymentGrams; // NEW: grams added in most recent payment

  EnrolledScheme({
    required this.id,
    required this.schemeId,
    required this.name,
    required this.totalAmount,
    required this.amountPaid,
    required this.amountBalance,
    required this.monthsPaid,
    required this.totalMonths,
    required this.lastPaymentDate,
    required this.nextDueDate,
    required this.isWeightBased,
    required this.accumulatedGrams,
    required this.monthlyAmount,
    this.lastPaymentGrams = 0.0, // NEW
  });
}