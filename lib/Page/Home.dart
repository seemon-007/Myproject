import 'package:Feedme/Page/ProfilePage.dart';
import 'package:Feedme/Page/HomePage.dart';
import 'package:Feedme/Page/cart_provider.dart';
import 'package:Feedme/Page/login.dart';
import 'package:Feedme/Page/payment.dart';
import 'package:Feedme/Page/product_list.dart';
import 'package:Feedme/Page/CartPage.dart';
import 'package:flutter/material.dart';
import 'package:Feedme/Page/register.dart';
import 'package:provider/provider.dart';
import 'package:Feedme/Page/Home.dart';
import 'package:Feedme/Page/HomePage.dart';
import 'BasePage.dart';

void main() => runApp(LinkPage());

class LinkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        return MaterialApp(
          title: 'Flutter Link Page Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(),
            '/Product': (context) => ProductListPage(),
            '/Cart': (context) => CartPage(),
            '/User': (context) => ProfilePage(),
            '/Payment': (context) => PaymentPage(),
            '/register': (context) => RegisterPage(),
          },
        );
      }),
    );
  }
}

