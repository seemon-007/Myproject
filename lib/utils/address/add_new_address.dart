import 'package:flutter/material.dart';
import 'package:Feedme/utils/address/address.dart';

class AddNewAddress extends StatelessWidget {
  const AddNewAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('NewAddress'),),backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'ชื่อ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15.0),
            const TextField(
              decoration: InputDecoration(
                labelText: 'ที่อยู่',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15.0),
            const TextField(
              decoration: InputDecoration(
                labelText: 'ตำบล',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15.0),
            const TextField(
              decoration: InputDecoration(
                labelText: 'อำเภอ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15.0),
            const TextField(
              decoration: InputDecoration(
                labelText: 'จังหวัด',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15.0),
            const TextField(
              decoration: InputDecoration(
                labelText: 'รหัสไปรษณีย์',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => UserAddress(address: '',)));
            } , child: const Text('ยืนยัน'))
          ],
        ),
      ),
    );
  }
}