import 'package:flutter/material.dart';
import 'package:Feedme/Page/product.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  // ดึงสินค้าในตะกร้าตาม id
  Product getItemById(int id) {
    return _cartItems.firstWhere(
          (item) => item.id == id,
    );
  }

  // เพิ่มสินค้าไปยังตะกร้า
  void addProduct(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  // ลบสินค้าออกจากตะกร้าโดยใช้ index
  void removeProduct(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // อัปเดตจำนวนสินค้าในตะกร้า
  void updateQuantity(int id, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _cartItems[index].quantity = quantity; // ฟิลด์นี้ต้องอยู่ใน Product
      notifyListeners();
    }
  }

  // ล้างตะกร้าสินค้า
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // ดึงรายการสินค้าในตะกร้า
  List<Product> getItems() {
    return _cartItems;
  }

  // คำนวณราคารวมทั้งหมด
  double getTotalPrice() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  // คำนวณจำนวนสินค้าทั้งหมด
  int getTotalItems() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
