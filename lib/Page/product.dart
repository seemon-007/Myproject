import 'package:Feedme/Page/product.dart';
import 'package:Feedme/constants/config.dart';
class Product {
  final int id;
  final String productName;
  final double price;
  final String category;
  final int stock;
  final String size;
  final String imageUrl;
  int quantity;

  Product({
    required this.id,
    required this.productName,
    required this.price,
    required this.category,
    required this.stock,
    required this.size,
    required this.quantity,
    required this.imageUrl,
  });

  // สร้าง `Product.fromJson()` เพื่อรับค่าจาก API
  factory Product.fromJson(Map<String, dynamic> json) {
    // ตรวจสอบหมวดหมู่ให้ตรงกับ "Dog" และ "Cat"
    String category = json['category'] ?? "ไม่ระบุหมวดหมู่";
    if (category.toLowerCase().contains("dog")) {
      category = "สุนัข";
    } else if (category.toLowerCase().contains("cat")) {
      category = "แมว";
    }

    return Product(
      id: json['ID_product'] ?? 0, // ต้องตรงกับชื่อคีย์ฐานข้อมูล
      productName: json['product_name'] ?? "ไม่มีชื่อสินค้า",
      price: double.tryParse(json['price'].toString()) ?? 0.0, // รองรับ int/double
      category: category,
      stock: json['stock'] ?? 0,
      size: json['size'] ?? "ไม่ระบุขนาด",
      quantity: json['quantity'] ?? 1, // เพิ่มตัวแปร quantity และกำหนดค่าเริ่มต้น
      imageUrl: json['image_url'] != null
          ? "http://${Config.BASE_IP}:${Config.BASE_PORT}/uploads/${json['image_url']}"
          : "http://${Config.BASE_IP}:${Config.BASE_PORT}/uploads/default.png", // ป้องกัน null
    );
  }
}