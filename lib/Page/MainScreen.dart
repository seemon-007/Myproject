// import 'package:flutter/material.dart';
// import 'package:Feedme/Page/HomePage.dart';
// import 'package:Feedme/Page/product_list.dart';
// import 'package:Feedme/Page/CartPage.dart';
// import 'package:Feedme/Page/ProfilePage.dart';
//
// class MainScreen extends StatefulWidget {
//   @override
//   MainScreenState createState() => MainScreenState();
// }
//
// class MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//
//   // สำหรับการเรียกใช้จากหน้าอื่นๆ
//   void changeTab(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   // เช็คการเข้าถึง
//   @override
//   void initState() {
//     super.initState();
//     print("MainScreen initialized");
//   }
//
//
//   // สร้างหน้าต่างๆ แบบเลซี่โหลด
//   final List<Widget> _pages = [
//     HomePage(),
//     ProductListPage(),
//     CartPage(),
//     ProfilePage(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white70,
//         backgroundColor: Colors.blue,
//         type: BottomNavigationBarType.fixed,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//             backgroundColor: Colors.blue,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business),
//             label: 'Product',
//             backgroundColor: Colors.blue,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//             backgroundColor: Colors.blue,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Profile',
//             backgroundColor: Colors.blue,
//           ),
//         ],
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:Feedme/Page/HomePage.dart';
import 'package:Feedme/Page/product_list.dart';
import 'package:Feedme/Page/CartPage.dart';
import 'package:Feedme/Page/ProfilePage.dart';
import 'package:provider/provider.dart';
import 'package:Feedme/Page/cart_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // สำหรับการเรียกใช้จากหน้าอื่นๆ
  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    print("MainScreen initialized");
  }

  // สร้างหน้าต่างๆ แบบเลซี่โหลด
  Widget _buildPage(int index) {
    // สร้างหน้าใหม่ทุกครั้งที่มีการเรียกใช้งาน เพื่อให้แน่ใจว่า Provider ทำงานถูกต้อง
    switch (index) {
      case 0: return HomePage();
      case 1: return ProductListPage();
      case 2: return CartPage();
      case 3: return ProfilePage();
      default: return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบว่ามี CartProvider ในบริบทหรือไม่
    // ถ้าไม่มี ให้สร้างขึ้นมาใหม่
    CartProvider? cartProvider;
    try {
      cartProvider = Provider.of<CartProvider>(context, listen: false);
    } catch (e) {
      print("CartProvider not found in context. Creating a new one.");
      // ถ้าไม่มี CartProvider ให้ครอบด้วย Provider
      return ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: _buildMainScreen(),
      );
    }

    // ถ้ามี CartProvider อยู่แล้ว
    return _buildMainScreen();
  }

  Widget _buildMainScreen() {
    return Scaffold(
      body: _buildPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Product',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}