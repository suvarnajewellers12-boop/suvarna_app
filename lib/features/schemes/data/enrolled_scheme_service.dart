import '../models/enrolled_scheme.dart';

class EnrolledSchemeService {
  static Future<List<EnrolledScheme>> getUserSchemes() async {
    await Future.delayed(const Duration(milliseconds: 800));

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

      EnrolledScheme(
        id: "2",
        name: "Suvarna Heritage Plan",
        totalAmount: 120000,
        amountPaid: 30000,
        amountBalance: 90000,
        monthsPaid: 6,
        totalMonths: 24,
        lastPaymentDate: "10 Jan 2026",
        nextDueDate: "10 Feb 2026",
      ),

    ];
  }
}