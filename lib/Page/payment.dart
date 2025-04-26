import 'dart:convert';
import 'package:Feedme/Page/CartPage.dart';
import 'package:Feedme/Page/product_list.dart';
import 'package:Feedme/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // สำหรับ API call
import 'package:provider/provider.dart';
import 'package:Feedme/Page/cart_provider.dart';
import 'package:Feedme/Page/mapPage.dart'; // สำหรับ MapPage
import 'package:latlong2/latlong.dart'; // สำหรับ LatLng

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  LatLng _selectedLocation = LatLng(13.7563, 100.5018);
  String _selectedLocationDetails = "กรุงเทพมหานคร, ประเทศไทย";
  String _deliveryMethod = "จัดส่ง"; // ตัวเลือกเริ่มต้นคือ "จัดส่ง"

  Future<void> saveOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    double totalPrice = cartProvider.getTotalPrice();
    double shippingCost = _deliveryMethod == "จัดส่ง" ? 50.0 : 0.0;
    double grandTotal = totalPrice + shippingCost;

    final orderData = {
      "customerId": 14,
      "product_name": cartProvider
          .getItems()
          .map((item) => item.productName)
          .join(", "), // ✅ เปลี่ยนชื่อ key ให้ตรงกับ API
      "shippingRate": shippingCost,
      "total": grandTotal,
    };

    print("🔍 Order Data being sent: $orderData"); // ✅ Debug

    try {
      final response = await http.post(
        Uri.parse('http://${Config.BASE_IP}:${Config.BASE_PORT}/api/orders/save'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      print("📝 Response Status: ${response.statusCode}");
      print("📝 Response Body: ${response.body}");

      if (response.statusCode == 201) {
        // ✅ แสดงป็อปอัป และกลับไปหน้า CartPage
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("✅ ชำระเงินสำเร็จ"),
              content: Text("คำสั่งซื้อของคุณได้ถูกบันทึกเรียบร้อยแล้ว"),
              actions: <Widget>[
                TextButton(
                  child: Text("ตกลง"),
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด AlertDialog
                    Navigator.popUntil(context,
                        ModalRoute.withName('/CartPage')); // ✅ กลับไปหน้า Cart
                  },
                ),
              ],
            );
          },
        );

        // ✅ ล้างตะกร้าหลังจากสั่งซื้อสำเร็จ
        cartProvider.clearCart();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("❌ เกิดข้อผิดพลาด"),
              content: Text("ไม่สามารถบันทึกคำสั่งซื้อได้ โปรดลองใหม่อีกครั้ง"),
              actions: <Widget>[
                TextButton(
                  child: Text("ตกลง"),
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด AlertDialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("❌ Error sending order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    double totalPrice = cartProvider.getTotalPrice();
    double shippingCost = _deliveryMethod == "จัดส่ง" ? 50.0 : 0.0;
    double grandTotal = totalPrice + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paymant",
          style: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความเป็นสีขาว
        ),
        backgroundColor: Colors.blue, // สีพื้นหลังของ AppBar
        elevation: 0,
        centerTitle: true, // เอาเงาของ AppBar ออก
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ที่อยู่จัดส่ง",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            InkWell(
              onTap: () async {
                final LatLng? newLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );

                if (newLocation != null) {
                  setState(() {
                    _selectedLocation = newLocation;
                    _selectedLocationDetails =
                        "Lat: ${newLocation.latitude}, Lng: ${newLocation.longitude}";
                  });
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedLocationDetails,
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.location_on, color: Colors.red),
                ],
              ),
            ),

            SizedBox(height: 20),

            Text("วิธีการรับสินค้า",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _deliveryMethod = "จัดส่ง";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _deliveryMethod == "จัดส่ง"
                        ? Colors.blue
                        : Colors.grey[200],
                    foregroundColor: _deliveryMethod == "จัดส่ง"
                        ? Colors.white
                        : Colors.black,
                    minimumSize: Size(150, 50),
                  ),
                  child: Text("จัดส่ง"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _deliveryMethod = "รับที่ร้าน";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _deliveryMethod == "รับที่ร้าน"
                        ? Colors.blue
                        : Colors.grey[200],
                    foregroundColor: _deliveryMethod == "รับที่ร้าน"
                        ? Colors.white
                        : Colors.black,
                    minimumSize: Size(150, 50),
                  ),
                  child: Text("รับที่ร้าน"),
                ),
              ],
            ),

            SizedBox(height: 20),

            Divider(),

            Text("สรุปคำสั่งซื้อ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ReusableWidget(title: "ราคาสินค้าทั้งหมด", value: totalPrice),
            ReusableWidget(title: "ค่าจัดส่ง", value: shippingCost),
            ReusableWidget(title: "ราคารวม", value: grandTotal),

            Spacer(),

            // showDialog(context: context, builder: (BuildContext context) {
            //   return AlertDialog(
            //     title: Text("ยืนยันการชำระเงิน"),
            //     content: Text("คุณต้องการชำระเงินหรือไม่?"),
            //     actions: <Widget>[
            //       TextButton(
            //         child: Text("ยกเลิก"),
            //         onPressed: () {
            //           Navigator.of(context).pop();
            //         },
            //       ),
            //       TextButton(
            //         child: Text("ยืนยัน"),
            //         onPressed: () {
            //
            //       })
            //     ]
            // })

            // ElevatedButton(
            //   onPressed:  saveOrder, // เรียกฟังก์ชัน saveOrder
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: Size(double.infinity, 50),
            //   ),
            //   child: Text("ชำระเงิน"),
            // ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("ยืนยันการชำระเงิน"),
                        content: Text("คุณต้องการชำระเงินหรือไม่?"),
                        actions: [
                          TextButton(
                            child: Text("ยืนยัน"),
                            onPressed: () {
                              saveOrder();
                              Provider.of<CartProvider>(context, listen: false).clearCart(); // เคลียร์สินค้า
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProductListPage())
                              );

                              },
                          ),
                        ],
                      );
                    });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("ชำระเงิน"),
            ),
          ],
        ),
      ),
    );
  }
}
