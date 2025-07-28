import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/product_model.dart';
import '../helpers/notification_helper.dart';

class ProductService {
  static Future<List<Product>> getAll() async {
    final res = await http.get(Uri.parse('$baseUrl/v1/products'));
    final List list = jsonDecode(res.body);
    return list.map((e) => Product.fromJson(e)).toList();
  }

  static Future<Product> create(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final createdProduct = Product.fromJson(jsonDecode(response.body));
      
      // Gửi thông báo tự động
      await NotificationHelper.sendProductCreatedNotification(createdProduct);
      
      return createdProduct;
    } else {
      throw Exception('Failed to create product');
    }
  }

  static Future<Product> update(String id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/v1/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );
    
    if (response.statusCode == 200) {
      final updatedProduct = Product.fromJson(jsonDecode(response.body));
      
      // Gửi thông báo tự động
      await NotificationHelper.sendProductUpdatedNotification(updatedProduct);
      
      return updatedProduct;
    } else {
      throw Exception('Failed to update product');
    }
  }

  static Future<void> delete(String id) async {
    // Lấy thông tin sản phẩm trước khi xóa để có tên
    final products = await getAll();
    final productToDelete = products.firstWhere((p) => p.id == id);
    
    final response = await http.delete(Uri.parse('$baseUrl/v1/products/$id'));
    
    if (response.statusCode == 200 || response.statusCode == 204) {
      // Gửi thông báo tự động
      await NotificationHelper.sendProductDeletedNotification(productToDelete.name);
    } else {
      throw Exception('Failed to delete product');
    }
  }
}