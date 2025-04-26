import 'package:Feedme/Page/cart_provider.dart';
import 'package:Feedme/Page/login.dart';
import 'package:Feedme/Page/payment.dart';
import 'package:Feedme/Page/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainScreen.dart';

void main() => runApp(LinkPage());

class LinkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Link Page Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),
          '/Payment': (context) => PaymentPage(),
          '/register': (context) => RegisterPage(),
          '/login': (context) => LoginPage(),
        },
      ),
    );
  }
}