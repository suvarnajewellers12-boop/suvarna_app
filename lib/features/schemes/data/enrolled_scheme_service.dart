import '../models/enrolled_scheme.dart';

class EnrolledSchemeService {
  static Future<List<EnrolledScheme>> getUserSchemes() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      EnrolledScheme(
        id: "1",
        name: "Suvarna Gold Savings",
        totalAmount: 11000,
        amountPaid: 8000,
        amountBalance: 3000,
        monthsPaid: 8,
        totalMonths: 11,
        lastPaymentDate: "15 Jan 2026",
        nextDueDate: "15 Feb 2026",
      ),
    ];
  }
}