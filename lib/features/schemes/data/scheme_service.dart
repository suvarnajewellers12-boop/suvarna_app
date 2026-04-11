import 'dart:convert';
import 'package:http/http.dart' as http;
import 'scheme_model.dart';

class SchemeService {
  static Future<List<SchemeModel>> getSchemes() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://suvarnagold-16e5.vercel.app/api/schemes/all',
        ),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RAW BODY: ${response.body}");

      if (response.statusCode != 200) {
        return [];
      }

      final decoded = jsonDecode(response.body);

      if (decoded == null || decoded["schemes"] == null) {
        return [];
      }

      final List schemes = decoded["schemes"];

      return schemes.map((item) {
        return SchemeModel.fromJson(item);
      }).toList();
    } catch (e) {
      print("SCHEME FETCH ERROR: $e");
      return [];
    }
  }
}