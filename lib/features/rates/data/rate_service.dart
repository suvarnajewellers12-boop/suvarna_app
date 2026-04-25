import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rate_model.dart';

class RateService {
  static Future<List<RateModel>> getRates() async {
    try {
      final response = await http.get(
        Uri.parse("https://suvarnagold-16e5.vercel.app/api/rates"),
      );

      print("RATE STATUS: ${response.statusCode}");
      print("RATE BODY: ${response.body}");

      if (response.statusCode != 200) {
        return [];
      }

      final data = jsonDecode(response.body);

      return [
        RateModel(
          metal: "Gold 24K",
          rate: _cleanRate(data["gold24"]),
        ),
        RateModel(
          metal: "Gold 22K",
          rate: _cleanRate(data["gold22"]),
        ),
        RateModel(
          metal: "Gold 18K",
          rate: _cleanRate(data["gold18"]),
        ),
        RateModel(
          metal: "Silver",
          rate: _cleanRate(data["silver"]),
        ),
      ];
    } catch (e) {
      print("RATE ERROR: $e");
      return [];
    }
  }

  static double _cleanRate(dynamic value) {
    return double.tryParse(
      value.toString().replaceAll("₹", "").replaceAll(",", ""),
    ) ?? 0;
  }
}