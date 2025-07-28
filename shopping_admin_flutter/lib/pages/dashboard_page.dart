import 'package:flutter/material.dart';
import '../services/product_service.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _productCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    final products = await ProductService.getAll();
    setState(() {
      _productCount = products.length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Trang quản trị",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(Icons.shopping_cart, size: 40),
                        title: Text("Tổng số sản phẩm"),
                        trailing: Text(
                          '$_productCount',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Bạn có thể thêm nhiều widget thống kê khác tại đây
                  ],
                ),
              ),
    );
  }
}