import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/product_model.dart';

class ProductService {
  static Future<List<Product>> getAll() async {
    final res = await http.get(Uri.parse('$baseUrl/v1/products'));
    final List list = jsonDecode(res.body);
    return list.map((e) => Product.fromJson(e)).toList();
  }

  static Future<void> create(Product product) async {
    await http.post(
      Uri.parse('$baseUrl/v1/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
  }

  static Future<void> update(String id, Product product) async {
    await http.put(
      Uri.parse('$baseUrl/v1/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
  }

  static Future<void> delete(String id) async {
    await http.delete(Uri.parse('$baseUrl/v1/products/$id'));
  }
}