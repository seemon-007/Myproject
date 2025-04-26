import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_productlist.dart';

class ProductlistPage extends StatefulWidget {
  @override
  _ProductlistPageState createState() => _ProductlistPageState();
}

class _ProductlistPageState extends State<ProductlistPage> {
  List<Product> products = [];

  // โหลดข้อมูลจาก SharedPreferences
  Future<void> loadProductsFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? productList = prefs.getStringList('products');
    if (productList != null) {
      setState(() {
        products = productList.map((product) => Product.fromJson(jsonDecode(product))).toList();
      });
    }
  }

  Future<void> saveProductsToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = products.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList('products', productList);
  }


  @override
  void initState() {
    super.initState();
    loadProductsFromPreferences(); // โหลดข้อมูลเมื่อหน้าเริ่มต้น
  }

  void addProduct(Product product) {
    setState(() {
      products.add(product);
    });
    saveProductsToPreferences(); // บันทึกข้อมูลเมื่อมีการเพิ่มสินค้า
  }

  void removeProduct(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
          actions: [
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                setState(() {
                  products.removeAt(index);
                });
                saveProductsToPreferences(); // บันทึกข้อมูลใหม่หลังลบสินค้า
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('รายการสินค้า'), backgroundColor: Colors.blue),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image(
                            image: products[index].imageUrl.isNotEmpty
                                ? FileImage(File(products[index].imageUrl))
                                : AssetImage('assets/default.jpg') as ImageProvider,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index].product_name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text('ราคา: ${products[index].price} บาท'),
                              Text('จำนวน: ${products[index].stock}'),
                              Text(
                                'ขนาด: ${products[index].size}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => removeProduct(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductlist(
                        addProduct: addProduct,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'เพิ่มรายการสินค้า',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String product_name;
  final String price;
  final String stock;
  final String size;
  final String imageUrl;

  Product({
    required this.product_name,
    required this.price,
    required this.stock,
    required this.size,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'product_name': product_name,
    'price': price,
    'quantity': stock,
    'size': size,
    'imageUrl': imageUrl,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    product_name: json['product_name'],
    price: json['price'],
    stock: json['quantity'],
    size: json['size'],
    imageUrl: json['imageUrl'],
  );
}
