import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/session_manager.dart';
import '../models/enrolled_scheme.dart';

class EnrolledSchemeService {
  static Future<List<EnrolledScheme>> getUserSchemes() async {
    try {
      final token = await SessionManager.getToken();

      if (token == null) {
        return [];
      }

      final response = await http.get(
        Uri.parse(
          "https://suvarna-jewellers-customer-backend.vercel.app/api/schemes/my",
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("ENROLLED STATUS: ${response.statusCode}");
      print("ENROLLED BODY: ${response.body}");

      if (response.statusCode != 200) {
        return [];
      }

      final data = jsonDecode(response.body);

      final List schemes = data["schemes"] ?? [];

      return schemes.map<EnrolledScheme>((e) {
        print("RAW ITEM: $e");
        print("RAW SCHEME: ${e["Scheme"]}");

        final scheme = e["Scheme"] ?? {};

        final monthlyAmount =
            int.tryParse(scheme["monthlyAmount"].toString()) ?? 0;

        final durationMonths =
            int.tryParse(scheme["durationMonths"].toString()) ?? 1;

        final installmentsPaid =
            int.tryParse(e["installmentsPaid"].toString()) ?? 0;

        final totalPaid =
            int.tryParse(e["totalPaid"].toString()) ?? 0;

        final remainingAmount =
            int.tryParse(e["remainingAmount"].toString()) ?? 0;

        print("NAME: ${scheme["name"]}");
        print("TOTAL PAID: $totalPaid");
        print("MONTHS: $installmentsPaid");

        final rawDate = DateTime.tryParse(e["startDate"]?.toString() ?? "");

        final lastDate = rawDate != null
            ? DateTime(
          rawDate.year,
          rawDate.month + (installmentsPaid > 0 ? installmentsPaid - 1 : 0),
          rawDate.day,
        )
            : null;

        final formattedDate = lastDate != null
            ? "${lastDate.day.toString().padLeft(2, '0')}-${lastDate.month.toString().padLeft(2, '0')}-${lastDate.year}"
            : "";

        final nextDate = rawDate != null
            ? DateTime(
          rawDate.year,
          rawDate.month + installmentsPaid,
          rawDate.day,
        )
            : null;

        final formattedNextDate = nextDate != null
            ? "${nextDate.day.toString().padLeft(2, '0')}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.year}"
            : "";

        return EnrolledScheme(
          id: e["id"]?.toString() ?? "",
          schemeId: e["schemeId"]?.toString() ?? "",
          name: scheme["name"]?.toString() ?? "Unnamed Scheme",
          totalAmount: monthlyAmount * durationMonths,
          amountPaid: totalPaid,
          amountBalance: remainingAmount,
          monthsPaid: installmentsPaid,
          totalMonths: durationMonths,
          lastPaymentDate: formattedDate,
          nextDueDate: formattedNextDate,
        );
      }).toList();
    } catch (e) {
      print("ENROLLED FETCH ERROR: $e");

      return [];
    }
  }
}