import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'productlist.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:Feedme/constants/config.dart';
class AddProductlist extends StatefulWidget {
  final Function(Product) addProduct;

  AddProductlist({required this.addProduct});

  @override
  _AddProductlistState createState() => _AddProductlistState();
}

class _AddProductlistState extends State<AddProductlist> {
  final product_nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final sizeController = TextEditingController();
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();
  Future<void> _addProductToApi(Product product) async {
    const String apiUrl = 'http://${Config.BASE_IP}:${Config.BASE_PORT}/api/products/add'; // เปลี่ยนเป็น URL จริง

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // เพิ่มข้อมูลสินค้า
      request.fields['product_name'] = product.product_name;
      request.fields['price'] = product.price.toString();
      request.fields['size'] = product.size;
      request.fields['stock'] = product.stock.toString();

      // เพิ่มไฟล์รูปภาพ (ถ้ามี)
      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // ต้องตรงกับ `upload.single("image")` ใน Express.js
            _imageFile!.path,
            contentType: MediaType('image', 'jpeg'), // กำหนด MIME type
          ),
        );
      }

      // ส่งคำขอไปยังเซิร์ฟเวอร์
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เพิ่มสินค้าสำเร็จ')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: ${await response.stream.bytesToString()}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ปรับขนาดหน้าจอเมื่อคีย์บอร์ดปรากฏ
      appBar: AppBar(title: Text('เพิ่มสินค้า')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // กรอบสำหรับแสดงรูปภาพ
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _imageFile == null
                  ? Center(child: Text('ยังไม่มีรูปภาพ', textAlign: TextAlign.center))
                  : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            // ปุ่มเลือกรูปภาพ
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text('เลือกรูปภาพ', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            // กรอกข้อมูลสินค้า
            TextField(
              controller: product_nameController,
              decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'ราคา'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'จำนวน'),
              keyboardType: TextInputType.number,
             ),
            TextField(
              controller: sizeController,
              decoration: InputDecoration(labelText: 'ขนาด'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (product_nameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    sizeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
                  );
                  return;
                }

                final product = Product(
                  product_name: product_nameController.text,
                  price: priceController.text,
                   stock: stockController.text,
                  size: sizeController.text,
                  imageUrl: _imageFile?.path ?? '',
                );

                _addProductToApi(product); // เรียก API
                widget.addProduct(product); // ส่งสินค้าไปยัง `ProductlistPage`
                Navigator.pop(context); // ปิดหน้าเพิ่มสินค้า
              },
              child: Text('บันทึก'),
            ),

          ],
        ),
      ),
    );
  }
}
