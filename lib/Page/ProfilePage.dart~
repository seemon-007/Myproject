// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:Feedme/Page/login.dart';
// import 'package:Feedme/utils/BtnPage.dart';
// import 'package:Feedme/Page/BasePage.dart';
// import 'package:Feedme/utils/Orderhistory/Order_history.dart';
// import 'package:Feedme/utils/address/address.dart';
// import 'package:Feedme/utils/account_setting.dart';
// import 'package:Feedme/utils/userprofile/userprofile.dart';
// import 'package:Feedme/utils/userdata.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   late Future<User> futureUser;
//   int customerId = 33; // สมมติว่าเป็น ID ของผู้ใช้ที่ล็อกอินอยู่
//   Map<String, dynamic>? localUserData; // 🔹 ใช้เก็บข้อมูลจาก SharedPreferences
//
//   @override
//   void initState() {
//     super.initState();
//     checkUserData(); //  ตรวจสอบว่ามีข้อมูลผู้ใช้ถูกบันทึกหรือไม่
//     loadUserData(); //  โหลดข้อมูลจาก SharedPreferences
//     futureUser = UserService().fetchUserById(customerId);
//   }
//
//   //  โหลดข้อมูลผู้ใช้จาก SharedPreferences
//   Future<void> loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userDataString = prefs.getString('user_data');
//
//     if (userDataString != null) {
//       setState(() {
//         localUserData = jsonDecode(userDataString);
//       });
//       print(" โหลดข้อมูลผู้ใช้จาก SharedPreferences: $localUserData");
//     } else {
//       print(" ไม่มีข้อมูลผู้ใช้ใน SharedPreferences");
//     }
//   }
//
//   //  ตรวจสอบว่าข้อมูลใน SharedPreferences มีอยู่จริงหรือไม่
//   Future<void> checkUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userDataString = prefs.getString('user_data');
//
//     if (userDataString != null) {
//       print(" ข้อมูลผู้ใช้ที่ถูกบันทึก: $userDataString");
//     } else {
//       print(" ไม่มีข้อมูลผู้ใช้ใน SharedPreferences");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BasePage(
//       index: 3,
//       body:
//       Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Profile",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           backgroundColor: Colors.blue,
//           elevation: 0,
//           centerTitle: true,
//         ),
//         body: FutureBuilder<User>(
//           future: futureUser,
//           builder: (context, snapshot) {
//             //  ค่าเริ่มต้นหาก API โหลดไม่สำเร็จ (ใช้ SharedPreferences แทน)
//             User fallbackUser = localUserData != null
//                 ? User(
//               customerId: localUserData?["customer_id"] ?? 0,
//               name: localUserData?["name"] ?? "ไม่พบชื่อ",
//               email: localUserData?["email"] ?? "ไม่พบอีเมล",
//               phone: localUserData?["phone"] ?? "ไม่พบเบอร์โทร",
//               address: localUserData?["address"] ?? "ไม่พบที่อยู่",
//               role: localUserData?["role"] ?? "guest",
//             )
//                 : User(
//               customerId: 0,
//               name: "กำลังโหลด...",
//               email: "กำลังโหลด...",
//               phone: "กำลังโหลด...",
//               address: "กำลังโหลด...",
//               role: "guest",
//             );
//
//             //  ใช้ข้อมูลจาก API ถ้ามี
//             User user = snapshot.hasData ? snapshot.data! : fallbackUser;
//
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//
//                   //  User Profile Section
//                   Userprofile(user: user),
//
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         /// ที่อยู่จัดส่ง
//                         const SizedBox(height: 20),
//                         AccountSetting(
//                           icon: Icons.home,
//                           title: 'ที่อยู่จัดส่ง',
//                           onTap: snapshot.hasData || localUserData != null
//                               ? () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) =>
//                                       UserAddress(address: user.address)),
//                             );
//                           }
//                               : () {}, //  ใช้ `{}` แทน `null`
//                         ),
//
//                         const SizedBox(height: 10),
//
//                         /// ประวัติการสั่งซื้อ
//                         AccountSetting(
//                           icon: Icons.timer,
//                           title: 'ประวัติการซื้อของ',
//                           onTap: snapshot.hasData || localUserData != null
//                               ? () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) =>
//                                       OrderHistory(customerId: user.customerId)),
//                             );
//                           }
//                               : () {}, //  ใช้ `{}` แทน `null`
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // ปุ่ม Logout
//                   Center(
//                     child: TextButton(
//                       onPressed: () async {
//                         SharedPreferences prefs =
//                         await SharedPreferences.getInstance();
//                         await prefs.clear(); // 🔹 ล้างข้อมูล SharedPreferences
//                         Navigator.pushReplacement(
//                             context, MaterialPageRoute(builder: (_) => LoginPage()));
//                       },
//                       child:
//                       const Text('Logout', style: TextStyle(color: Colors.red)),
//                     ),
//                   ),
//
//                   //  **แสดง Loading Indicator หากกำลังโหลด**
//                   if (snapshot.connectionState == ConnectionState.waiting)
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: CircularProgressIndicator(),
//                     ),
//
//                   //  **แสดงข้อความ Error หากโหลดล้มเหลว**
//                   if (snapshot.hasError)
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         children: [
//                           Text(
//                             "เกิดข้อผิดพลาด: ไม่สามารถโหลดข้อมูลได้",
//                             style: TextStyle(color: Colors.red),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             "กำลังใช้ข้อมูลที่บันทึกไว้ในเครื่อง",
//                             style: TextStyle(color: Colors.blue),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Feedme/Page/login.dart';
import 'package:Feedme/utils/Orderhistory/Order_history.dart';
import 'package:Feedme/utils/address/address.dart';
import 'package:Feedme/utils/account_setting.dart';
import 'package:Feedme/utils/userprofile/userprofile.dart';
import 'package:Feedme/utils/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/config.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> futureUser;
  int customerId = 33;
  Map<String, dynamic>? localUserData;

  @override
  void initState() {
    super.initState();
    checkUserData();
    loadUserData();
    futureUser = UserService().fetchUserById(customerId);
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      setState(() {
        localUserData = jsonDecode(userDataString);
      });
      print(" โหลดข้อมูลผู้ใช้จาก SharedPreferences: $localUserData");
    } else {
      print(" ไม่มีข้อมูลผู้ใช้ใน SharedPreferences");
    }
  }

  Future<void> checkUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      print(" ข้อมูลผู้ใช้ที่ถูกบันทึก: $userDataString");
    } else {
      print(" ไม่มีข้อมูลผู้ใช้ใน SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          User fallbackUser = localUserData != null
              ? User(
            customerId: localUserData?["customer_id"] ?? 0,
            name: localUserData?["name"] ?? "ไม่พบชื่อ",
            email: localUserData?["email"] ?? "ไม่พบอีเมล",
            phone: localUserData?["phone"] ?? "ไม่พบเบอร์โทร",
            address: localUserData?["address"] ?? "ไม่พบที่อยู่",
            role: localUserData?["role"] ?? "guest",
          )
              : User(
            customerId: 0,
            name: "กำลังโหลด...",
            email: "กำลังโหลด...",
            phone: "กำลังโหลด...",
            address: "กำลังโหลด...",
            role: "guest",
          );

          User user = snapshot.hasData ? snapshot.data! : fallbackUser;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),

                Userprofile(user: user),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      AccountSetting(
                        icon: Icons.home,
                        title: 'ที่อยู่จัดส่ง',
                        onTap: snapshot.hasData || localUserData != null
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => UserAddress(address: user.address)),
                          );
                        }
                            : () {},
                      ),

                      const SizedBox(height: 10),

                      AccountSetting(
                        icon: Icons.timer,
                        title: 'ประวัติการซื้อของ',
                        onTap: snapshot.hasData || localUserData != null
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OrderHistory(customerId: user.customerId)),
                          );
                        }
                            : () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => LoginPage()));
                    },
                    child: const Text('Logout', style: TextStyle(color: Colors.red)),
                  ),
                ),

                if (snapshot.connectionState == ConnectionState.waiting)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),

                if (snapshot.hasError)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "เกิดข้อผิดพลาด: ไม่สามารถโหลดข้อมูลได้",
                          style: TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "กำลังใช้ข้อมูลที่บันทึกไว้ในเครื่อง",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}