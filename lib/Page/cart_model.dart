class Cart {
  final int id;
  final String productName;
  final double price;
  final String category;
  final int stock;
  final String size;
   int quantity;
  final String imageUrl;

  Cart({
    required this.id,
    required this.productName,
    required this.price,
    required this.category,
    required this.stock,
    required this.size,
    required this.quantity,
    required this.imageUrl,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['product_id'] != null ? (json['product_id'] as num).toInt() : 0,
      productName: json['product_name'] ?? "ไม่มีชื่อสินค้า",
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      category: json['category'] ?? "ไม่มีหมวดหมู่",
      stock: json['stock'] != null ? (json['stock'] as num).toInt() : 0,
      size: json['size'] ?? "ไม่ระบุขนาด",
      quantity: json['quantity'] ?? 1,
      imageUrl: json['image_url'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'product_name': productName,
      'price': price,
      'category': category,
      'stock': stock,
      'size': size,
      'quantity': quantity,
      'image_url': imageUrl,
    };
  }
}