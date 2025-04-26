import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:Feedme/constants/config.dart';
import 'package:http/http.dart' as http;
class ReportMonth extends StatefulWidget {
  @override
  _ReportMonthState createState() => _ReportMonthState();
}

class _ReportMonthState extends State<ReportMonth> {
  List<Map<String, dynamic>> allOrders = [];

  @override
  void initState() {
    super.initState();
    _setDefaultLocale(); //  กำหนด Locale
    _loadOrders();
  }

  //  กำหนด locale ให้ `intl` ป้องกัน DateFormat Error
  void _setDefaultLocale() {
    Intl.defaultLocale = 'en_US'; // หรือใช้ 'th_TH' สำหรับภาษาไทย
  }
  Future<void> fetchOrdersFromDB() async {
    final String apiUrl = "http://${Config.BASE_IP}:${Config.BASE_PORT}/api/get_orders";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> orders = json.decode(response.body);

        // บันทึกลง SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('orders', json.encode(orders));

        print("✅ ดึงข้อมูลสำเร็จและบันทึกลง SharedPreferences");
      } else {
        throw Exception("❌ ไม่สามารถดึงข้อมูลคำสั่งซื้อได้");
      }
    } catch (error) {
      print("🚨 เกิดข้อผิดพลาดในการดึงข้อมูล: $error");
    }
  }
  //  ดึงข้อมูลคำสั่งซื้อจาก SharedPreferences และกรองตามเดือนปัจจุบัน
  Future<void> _loadOrders() async {
    await initializeDateFormatting('th_TH', null); // โหลด locale

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ordersString = prefs.getString('orders'); // ดึงข้อมูลจาก SharedPreferences

    print(" ค่าจาก SharedPreferences: $ordersString"); //  ตรวจสอบค่าที่ได้จาก SharedPreferences

    if (ordersString != null) {
      List<Map<String, dynamic>> allOrdersRaw = List<Map<String, dynamic>>.from(json.decode(ordersString));

      // ดึงเดือนและปีปัจจุบัน
      DateTime now = DateTime.now();
      String currentMonth = DateFormat('yyyy-MM', 'th_TH').format(now); //  ระบุ locale

      print(" เดือนปัจจุบันที่ใช้กรอง: $currentMonth");

      // กรองคำสั่งซื้อที่ตรงกับเดือนปัจจุบัน
      setState(() {
        allOrders = allOrdersRaw.where((order) {
          String orderDate = order['order_date'] ?? ''; //  ใช้ order_date จากฐานข้อมูล
          if (orderDate.length < 7) return false; // ป้องกัน error กรณีไม่มีวันที่
          String orderMonth = orderDate.substring(0, 7); // ตัดเฉพาะ "YYYY-MM"

          print(" ตรวจสอบ order_date: $orderDate (เดือนที่ใช้กรอง: $orderMonth)");
          return orderMonth == currentMonth; //  เช็คว่าเป็นเดือนเดียวกันหรือไม่
        }).toList();
      });

      print(" โหลดคำสั่งซื้อของเดือน: $currentMonth จำนวน: ${allOrders.length}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายงานสรุปรายเดือน'),
        backgroundColor: Colors.blue,
      ),
      body: allOrders.isEmpty
          ? Center(child: Text("ไม่มีคำสั่งซื้อในเดือนนี้"))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: allOrders.length,
        itemBuilder: (context, index) {
          final order = allOrders[index];

          // เช็คว่ามี product_name หรือไม่ ถ้าไม่มีให้ใช้ ['ไม่ระบุ']
          List<String> productNames = (order['product_name'] != null)
              ? order['product_name'].toString().split(', ')
              : ['ไม่ระบุ'];

          return buildOrderCard(
            customerName: order['customer_id'].toString(), // 📌 ใช้ customer_id
            totalPrice: order['total'] ?? 0.0,
            orderDate: order['order_date'] ?? 'ไม่ระบุ', // 📌 แสดงวันที่
            productNames: productNames, // 📌 ส่งข้อมูลสินค้า
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            final totalOrders = allOrders.length; // 📌 นับจำนวนคำสั่งซื้อ
            final totalRevenue = allOrders.fold<double>(
              0.0,
                  (sum, order) => sum + (order['total'] ?? 0.0), // ✅ ใช้ total ตรงจากฐานข้อมูล
            );

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('สรุปผลรวม'),
                  content: Text(
                    'จำนวนคำสั่งซื้อทั้งหมด: $totalOrders รายการ\n'
                        'รายได้รวมทั้งหมด: ${totalRevenue.toStringAsFixed(2)} บาท',
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

  // 📌 ฟังก์ชันสร้างกล่องแสดงคำสั่งซื้อ
  Widget buildOrderCard({
    required String customerName,
    required double totalPrice,
    required String orderDate,
    required List<String> productNames,
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
              'รหัสลูกค้า: $customerName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'วันที่สั่งซื้อ: $orderDate',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Divider(),
            Text(
              'รายการสินค้า:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            productNames.isNotEmpty
                ? Column(
              children: productNames.map((product) {
                return Text('- $product', style: TextStyle(fontSize: 14));
              }).toList(),
            )
                : Text('ไม่มีสินค้า', style: TextStyle(fontSize: 14, color: Colors.red)),
            Divider(),
            Text(
              'ราคารวม: ${totalPrice.toStringAsFixed(2)} บาท',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
