
import 'package:flutter/material.dart';
import 'package:Feedme/Page/login.dart';

import 'Product/product.dart';
import 'Report/ReportPage.dart';

void main() => runApp(LinkPageadmin());

class LinkPageadmin extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Flutter Link Page Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => ProductPageseting(),
            '/report': (context) => ReportPage(),
             // '/Cart': (context) => CartPage(),
              '/Login':(context) => LoginPage(),
            // '/Payment':(context) => PaymentPage(),
          },
        );
  }
}