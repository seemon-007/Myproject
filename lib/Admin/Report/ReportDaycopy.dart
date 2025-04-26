import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // ใช้สำหรับจัดการวันที่

class ReportDay extends StatefulWidget {
  @override
  _ReportDayState createState() => _ReportDayState();
}

class _ReportDayState extends State<ReportDay> {
  List<Map<String, dynamic>> dailyOrders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // ดึงข้อมูลคำสั่งซื้อเฉพาะของวันปัจจุบัน
  Future<void> _loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ordersString = prefs.getString('orders'); // คำสั่งซื้อทั้งหมด
    if (ordersString != null) {
      List<Map<String, dynamic>> allOrders = List<Map<String, dynamic>>.from(json.decode(ordersString));

      // ดึงวันที่ปัจจุบันในรูปแบบ YYYY-MM-DD
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // กรองข้อมูลให้เหลือเฉพาะคำสั่งซื้อของวันนี้
      setState(() {
        dailyOrders = allOrders.where((order) {
          return order['date'] == today; // ต้องแน่ใจว่า JSON มีฟิลด์ 'date'
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายงานสรุปรายวัน'),
        backgroundColor: Colors.blue,
      ),
      body: dailyOrders.isEmpty
          ? Center(child: Text("ไม่มีคำสั่งซื้อในวันนี้"))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dailyOrders.length,
        itemBuilder: (context, index) {
          final order = dailyOrders[index];
          return buildOrderCard(
            customerName: order['customerName'] ?? 'ไม่ระบุ',
            deliveryAddress: order['deliveryAddress'] ?? 'ไม่ระบุ',
            totalPrice: order['totalPrice'] ?? 0.0,
            orderDetails: List<Map<String, dynamic>>.from(order['orderDetails']),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            final totalQuantity = dailyOrders.fold<int>(
              0,
                  (sum, order) {
                final orderDetails = List<Map<String, dynamic>>.from(order['orderDetails']);
                return sum + orderDetails.fold<int>(
                  0,
                      (itemSum, item) => (item['quantity'] ?? 0) + itemSum,
                );
              },
            );

            final totalRevenue = dailyOrders.fold<double>(
              0.0,
                  (sum, order) {
                final orderDetails = List<Map<String, dynamic>>.from(order['orderDetails']);
                return sum + orderDetails.fold<double>(
                  0.0,
                      (itemSum, item) => itemSum + ((item['price'] ?? 0.0) * (item['quantity'] ?? 0)),
                );
              },
            );

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('สรุปผลรวมรายวัน'),
                  content: Text(
                    'จำนวนสินค้าทั้งหมด: $totalQuantity ชิ้น\n'
                        'รายได้รวมทั้งหมด: $totalRevenue บาท',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('ปิด'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('สรุปผลรวม'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างกล่องข้อมูลคำสั่งซื้อ
  Widget buildOrderCard({
    required String customerName,
    required String deliveryAddress,
    required double totalPrice,
    required List<Map<String, dynamic>> orderDetails,
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
              'ผู้สั่งซื้อ: $customerName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Text(
              'รายละเอียดสินค้า:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...orderDetails.map((item) {
              return Text(
                '- ${item['name']} จำนวน ${item['quantity']} ราคา ${item['price']} บาท',
                style: TextStyle(fontSize: 14),
              );
            }).toList(),
            Divider(),
            Text('ราคารวม: ${totalPrice.toStringAsFixed(2)} บาท'),
          ],
        ),
      ),
    );
  }
}
