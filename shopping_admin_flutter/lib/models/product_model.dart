class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['_id'] ?? json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'],
    price: json['price'] is num
        ? (json['price'] as num).toDouble()
        : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
    imageUrl: json['imageUrl'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    if (description != null) 'description': description,
    'price': price,
    if (imageUrl != null) 'imageUrl': imageUrl,
  };
}
