import 'dart:convert';
import 'package:Feedme/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportDay extends StatefulWidget {
  @override
  _ReportDayState createState() => _ReportDayState();
}

class _ReportDayState extends State<ReportDay> {
  List<Map<String, dynamic>> allOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // ✅ ดึงข้อมูลคำสั่งซื้อจาก API
  Future<void> _fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('http://${Config.BASE_IP}:${Config.BASE_PORT}/api/orders'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          allOrders = data.map<Map<String, dynamic>>((order) {
            return {
              "customer_id": order["customer_id"]?.toString() ?? "ไม่ระบุ",
              "product_name": order["product_name"] ?? "ไม่ระบุ",
              "total": double.tryParse(order["total"]?.toString() ?? "0.0") ?? 0.0,
              "order_date": order["order_date"] ?? "ไม่ระบุ",
            };
          }).toList();
        });

        print("✅ Orders fetched successfully: $allOrders");
      } else {
        print("❌ Failed to load orders: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("📌 UI Rebuilt. Orders count: ${allOrders.length}");

    return Scaffold(
      appBar: AppBar(title: Text('รายงานสรุปรายวัน'), backgroundColor: Colors.blue),
      body: allOrders.isEmpty
          ? Center(child: Text("ไม่มีคำสั่งซื้อในวันนี้"))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: allOrders.length,
        itemBuilder: (context, index) {
          final order = allOrders[index];
          return buildOrderCard(
            customerId: order['customer_id'].toString(),
            productName: order['product_name'],
            totalPrice: order['total'],
            orderDate: order['order_date'],
          );
        },
      ),
    );
  }

  // ✅ ฟังก์ชันสร้างกล่องแสดงคำสั่งซื้อ
  Widget buildOrderCard({
    required String customerId,
    required String productName,
    required double totalPrice,
    required String orderDate,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'รหัสลูกค้า: $customerId',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('สินค้า: $productName'),
            Text('ราคารวม: ${totalPrice.toStringAsFixed(2)} บาท'),
            Text('วันที่สั่งซื้อ: ${orderDate.split("T")[0]}'),  // ✅ แสดงเฉพาะวันที่
          ],
        ),
      ),
    );
  }}
