import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context, 
                '/product-form',
                arguments: product,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: product.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[100],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 60,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Không thể tải ảnh',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        color: Colors.grey[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Chưa có ảnh',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Product Name
            _buildInfoCard(
              title: 'Tên sản phẩm',
              content: product.name,
              icon: Icons.shopping_bag,
            ),
            const SizedBox(height: 16),

            // Price
            _buildInfoCard(
              title: 'Giá',
              content: '${product.price.toStringAsFixed(0)} VNĐ',
              icon: Icons.attach_money,
              contentColor: Colors.green[700],
            ),
            const SizedBox(height: 16),

            // Description
            _buildInfoCard(
              title: 'Mô tả',
              content: product.description?.isNotEmpty == true 
                  ? product.description! 
                  : 'Chưa có mô tả',
              icon: Icons.description,
              isDescription: true,
            ),
            const SizedBox(height: 16),

            // Product ID
            _buildInfoCard(
              title: 'ID sản phẩm',
              content: product.id,
              icon: Icons.tag,
              contentStyle: TextStyle(
                fontFamily: 'monospace',
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    Color? contentColor,
    TextStyle? contentStyle,
    bool isDescription = false,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue[600]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: contentStyle ?? TextStyle(
                fontSize: isDescription ? 16 : 18,
                color: contentColor ?? Colors.black87,
                height: isDescription ? 1.5 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
