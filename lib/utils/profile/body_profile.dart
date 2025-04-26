import 'package:flutter/material.dart';

import 'profile_menu.dart';

class BodyProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserProfile'),backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15.0),
            //profile img
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child:  CircleAvatar(backgroundImage: AssetImage("assetName"),
                    ),
                  ),
                  TextButton(onPressed: (){}, child: const Text("change")),
                ],
              ),
            ),

            //details
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 10),
            const Text("Profile Information"),
            const SizedBox(height: 10),

            profile_menu(title: 'Name :', value: 'ชื่อ',onPressed: () {}),
            profile_menu(onPressed: () {}, title: 'Username :', value: 'ชื่อเล่น'),

            //persanal
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 10),
            const Text("Personal Information"),
            const SizedBox(height: 10),

            profile_menu(title: 'User ID :', value: 'ไอดี',icon: Icons.copy,onPressed: () {}),
            profile_menu(title: 'Date of Birth :', value: 'วันเกิด',onPressed: () {}),
            profile_menu(title: 'E-mail :', value: 'อีเมล',onPressed: () {}),
            profile_menu(title: 'Phone Number :', value: 'เบอร์',onPressed: () {}),
            const Divider(),
            const SizedBox(height: 15),


          ],
        ),
      ),
    );
  }
}

