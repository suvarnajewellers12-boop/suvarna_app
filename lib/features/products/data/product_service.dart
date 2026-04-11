import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse("https://suvarnagold-16e5.vercel.app/api/productsimgs/list"),
      );

      print("PRODUCT STATUS: ${response.statusCode}");
      print("PRODUCT BODY: ${response.body}");

      if (response.statusCode != 200) {
        return [];
      }

      final List data = jsonDecode(response.body);

      return data.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      print("PRODUCT ERROR: $e");
      return [];
    }
  }
}