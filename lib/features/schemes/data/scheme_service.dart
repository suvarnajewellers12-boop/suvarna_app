import 'dart:convert';
import 'package:http/http.dart' as http;
import 'scheme_model.dart';

class SchemeService {
  static Future<List<SchemeModel>> getSchemes() async {
    final response = await http.get(
      Uri.parse('https://suvarnagold-16e5.vercel.app/api/schemes/all'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List schemes = data['schemes'];

      return schemes.map((e) => SchemeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load schemes');
    }
  }
}