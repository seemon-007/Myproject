import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  final int customerId; // ✅ เพิ่ม parameter customerId

  const OrderHistory({Key? key, required this.customerId}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ประวัติการซื้อของ")),
      body: Center(
        child: Text("แสดงประวัติการซื้อของสำหรับผู้ใช้ ID: ${widget.customerId}"),
      ),
    );
  }
}
