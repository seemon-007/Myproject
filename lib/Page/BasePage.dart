import 'package:Feedme/Page/product_list.dart';
import 'package:flutter/material.dart';

import 'CartPage.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';

// class BasePage extends StatefulWidget {
//   final Widget body;
//   final int index;
//
//   const BasePage({super.key, required this.body, required this.index});
//
//   @override
//   State createState(){
//     return BasePageState();
//   }
// }
//
// class BasePageState extends State<BasePage>{
//
//   final List<String> routes = ['/', '/Product', '/Cart','/User', '/Payment'];
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: widget.body,
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.blue,
//         currentIndex: widget.index,
//         selectedItemColor: Colors.white,
//         items: const <BottomNavigationBarItem> [
//           BottomNavigationBarItem(icon: Icon(Icons.home),
//             label: 'Home',
//             backgroundColor: Colors.blue,
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.business),
//             label: 'Product',
//             backgroundColor: Colors.blue,
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//             backgroundColor: Colors.blue,
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.account_circle),
//             label: 'Profile',
//             backgroundColor: Colors.blue,
//           ),
//
//         ],
//           onTap: (index) {
//             setState(() {
//               Navigator.pushNamed(context, routes[index]);
//             });
//           }
//       ),
//     );
//   }
// }




class BasePage extends StatefulWidget {
  final Widget body;
  final int index;

  const BasePage({super.key, required this.body, required this.index});

  @override
  State createState() {
    return _BasePageState();
  }
}

class _BasePageState extends State<BasePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index; // ✅ กำหนดค่าเริ่มต้นของ index ให้ตรงกับหน้าแรก
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // ✅ อัปเดต index ให้แสดงไอคอนที่เลือก
    });

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        if (index == 0) return HomePage();
        if (index == 1) return ProductListPage();
        if (index == 2) return CartPage();
        if (index == 3) return ProfilePage();
        return HomePage();
      }),
          // (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.body,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blue, // ✅ เปลี่ยนสีพื้นหลังของแถบ
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed, // ✅ ป้องกันแถบไอคอนขยับ
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Product'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
          ],
          onTap: _onTabTapped, // ✅ ใช้ฟังก์ชัน `_onTabTapped`
        ),
      ),
    );
  }
}
