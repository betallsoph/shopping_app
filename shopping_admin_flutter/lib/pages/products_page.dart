import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductsPage extends StatefulWidget {
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    _products = await ProductService.getAll();
    setState(() {});
  }

  void _delete(String id) async {
    await ProductService.delete(id);
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (_, i) {
          final p = _products[i];
          return ListTile(
            leading: p.imageUrl != null 
                ? Image.network(p.imageUrl!, width: 50, fit: BoxFit.cover)
                : Container(
                    width: 50, 
                    height: 50, 
                    color: Colors.grey[300],
                    child: Icon(Icons.image, color: Colors.grey[600]),
                  ),
            title: Text(p.name),
            subtitle: Text('${p.price} VNĐ'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _delete(p.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // TODO: show form tạo sản phẩm
        },
      ),
    );
  }
}
