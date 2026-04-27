import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/session_manager.dart';
import '../models/coupon_model.dart';

class CouponService {
  static const String _baseUrl =
      "https://suvarna-jewellers-customer-backend.vercel.app/api";

  static Future<List<CouponModel>> getMyCoupons() async {
    try {
      final token = await SessionManager.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse("$_baseUrl/coupons/my"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final List coupons = data["coupons"] ?? [];

      return coupons.map((e) => CouponModel.fromJson(e)).toList();
    } catch (e) {
      print("Coupon fetch error: $e");
      return [];
    }
  }
}