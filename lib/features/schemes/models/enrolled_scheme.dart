class EnrolledScheme {
  final String id;
  final String name;
  final int totalAmount;
  final int amountPaid;
  final int amountBalance;
  final int monthsPaid;
  final int totalMonths;
  final String lastPaymentDate;
  final String nextDueDate;

  EnrolledScheme({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.amountPaid,
    required this.amountBalance,
    required this.monthsPaid,
    required this.totalMonths,
    required this.lastPaymentDate,
    required this.nextDueDate,
  });
}