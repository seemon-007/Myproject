import 'package:flutter/material.dart';

class UserAddress extends StatelessWidget {
  final String address; // ✅ เพิ่ม parameter address

  const UserAddress({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ที่อยู่จัดส่ง"),
      backgroundColor: Colors.blue),
      body: Center(
        child: Text(address, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
