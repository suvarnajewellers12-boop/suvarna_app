import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/session_manager.dart';
import '../models/enrolled_scheme.dart';

class EnrolledSchemeService {
  static List<EnrolledScheme>? _cachedSchemes;
  static DateTime? _lastFetched;
  static const _cacheDuration = Duration(minutes: 5);

  static bool get _isCacheValid {
    if (_cachedSchemes == null || _lastFetched == null) return false;
    return DateTime.now().difference(_lastFetched!) < _cacheDuration;
  }

  static void invalidateCache() {
    _cachedSchemes = null;
    _lastFetched = null;
  }

  static Future<List<EnrolledScheme>> getUserSchemes({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid) return _cachedSchemes!;

    try {
      final token = await SessionManager.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse("https://suvarna-jewellers-customer-backend.vercel.app/api/schemes/my"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode != 200) return _cachedSchemes ?? [];

      final data = jsonDecode(response.body);
      final List enrollments = data["schemes"] ?? []; // these ARE enrollments directly

      final List<EnrolledScheme> result = [];

      for (final e in enrollments) {
        final scheme = e["Scheme"] ?? {}; // capital S — nested scheme details

        final monthlyAmount = int.tryParse(scheme["monthlyAmount"].toString()) ?? 0;
        final durationMonths = int.tryParse(scheme["durationMonths"].toString()) ?? 1;
        final installmentsPaid = int.tryParse(e["installmentsPaid"].toString()) ?? 0;
        final totalPaid = int.tryParse(e["totalPaid"].toString()) ?? 0;
        final remainingAmount = int.tryParse(e["remainingAmount"].toString()) ?? 0;
        final isWeightBased = scheme["isWeightBased"] == true;
        final accumulatedGrams = double.tryParse(e["accumulatedGrams"].toString()) ?? 0.0;

        final rawDate = DateTime.tryParse(e["startDate"]?.toString() ?? "");

        final lastDate = rawDate != null && installmentsPaid > 0
            ? DateTime(rawDate.year, rawDate.month + installmentsPaid - 1, rawDate.day)
            : null;

        final formattedDate = lastDate != null
            ? "${lastDate.day.toString().padLeft(2, '0')}-${lastDate.month.toString().padLeft(2, '0')}-${lastDate.year}"
            : "";

        final nextDate = rawDate != null
            ? DateTime(rawDate.year, rawDate.month + installmentsPaid, rawDate.day)
            : null;

        final formattedNextDate = installmentsPaid >= durationMonths
            ? "Completed"
            : nextDate != null
            ? "${nextDate.day.toString().padLeft(2, '0')}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.year}"
            : "";

        final List paymentHistory = e["PaymentHistory"] ?? [];
        final double lastPaymentGrams = paymentHistory.isNotEmpty
            ? double.tryParse(
            paymentHistory[0]["gramsAdded"]?.toString() ?? "0") ?? 0.0
            : 0.0;

        result.add(EnrolledScheme(
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
          isWeightBased: isWeightBased,
          accumulatedGrams: accumulatedGrams,
          monthlyAmount: monthlyAmount,
            lastPaymentGrams: lastPaymentGrams
        ));
      }

      _cachedSchemes = result;
      _lastFetched = DateTime.now();
      return result;
    } catch (e) {
      return _cachedSchemes ?? [];
    }
  }
}