import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/session_manager.dart';
import '../models/enrolled_scheme.dart';

class EnrolledSchemeService {
  // In-memory cache — lives for the app session
  static List<EnrolledScheme>? _cachedSchemes;
  static DateTime? _lastFetched;
  static const _cacheDuration = Duration(minutes: 5);

  static bool get _isCacheValid {
    if (_cachedSchemes == null || _lastFetched == null) return false;
    return DateTime.now().difference(_lastFetched!) < _cacheDuration;
  }

  // Call this after a payment — forces next getUserSchemes() to hit network
  static void invalidateCache() {
    _cachedSchemes = null;
    _lastFetched = null;
  }

  static Future<List<EnrolledScheme>> getUserSchemes({bool forceRefresh = false}) async {
    // Return cache if valid and not forced
    if (!forceRefresh && _isCacheValid) {
      return _cachedSchemes!;
    }

    try {
      final token = await SessionManager.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(
          "https://suvarna-jewellers-customer-backend.vercel.app/api/schemes/my",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode != 200) return _cachedSchemes ?? [];

      final data = jsonDecode(response.body);
      final List schemes = data["schemes"] ?? [];

      final result = schemes.map<EnrolledScheme>((e) {
        final scheme = e["Scheme"] ?? {};
        final monthlyAmount = int.tryParse(scheme["monthlyAmount"].toString()) ?? 0;
        final durationMonths = int.tryParse(scheme["durationMonths"].toString()) ?? 1;
        final installmentsPaid = int.tryParse(e["installmentsPaid"].toString()) ?? 0;
        final totalPaid = int.tryParse(e["totalPaid"].toString()) ?? 0;
        final remainingAmount = int.tryParse(e["remainingAmount"].toString()) ?? 0;

        final rawDate = DateTime.tryParse(e["startDate"]?.toString() ?? "");

        final lastDate = rawDate != null
            ? DateTime(rawDate.year, rawDate.month + (installmentsPaid > 0 ? installmentsPaid - 1 : 0), rawDate.day)
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

      // Store in cache
      _cachedSchemes = result;
      _lastFetched = DateTime.now();

      return result;
    } catch (e) {
      // On error, return stale cache if available — better than empty
      return _cachedSchemes ?? [];
    }
  }
}