import 'package:flutter/material.dart';
import '../userdata.dart'; // ✅ ตรวจสอบให้แน่ใจว่าไฟล์ userdata.dart มีอยู่

class Userprofile extends StatelessWidget {
  final User user; // ✅ ใช้คลาส User ที่ได้จาก userdata.dart

  const Userprofile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade300,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        SizedBox(height: 10),
        Text(user.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(user.email, style: TextStyle(fontSize: 16, color: Colors.grey)),
        Divider(thickness: 1, height: 30),
      ],
    );
  }
}
