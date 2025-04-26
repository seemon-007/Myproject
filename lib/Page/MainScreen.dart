import 'package:flutter/material.dart';
import 'package:Feedme/Page/HomePage.dart';
import 'package:Feedme/Page/product_list.dart';
import 'package:Feedme/Page/CartPage.dart';
import 'package:Feedme/Page/ProfilePage.dart';

class MainScreen extends StatefulWidget {
  static final GlobalKey<_MainScreenState> globalKey = GlobalKey<_MainScreenState>();

  @override
  _MainScreenState createState() => _MainScreenState();

  static void changeTab(BuildContext context, int index) {
    final state = globalKey.currentState;
    if (state != null) {
      state.changeTab(index);
    }
  }
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // เพิ่มเมธอดนี้เพื่อให้หน้าอื่นๆ สามารถเรียกใช้เพื่อเปลี่ยนแท็บได้
  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // สร้างหน้าต่างๆ แบบเลซี่โหลด (สร้างเมื่อต้องการใช้)
  final List<Widget> _pages = [
    HomePage(),
    ProductListPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: MainScreen.globalKey,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
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
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}