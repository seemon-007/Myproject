import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'order_detail.dart';


class OrderPage extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderPage> {
  List<Map<String, dynamic>> allOrders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ordersString = prefs.getString('orders');
    if (ordersString != null) {
      setState(() {
        allOrders = List<Map<String, dynamic>>.from(json.decode(ordersString));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('order'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: allOrders.length,
        itemBuilder: (context, index) {
          final order = allOrders[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetail(
                    customerName: order['customerName'],
                    deliveryAddress: order['deliveryAddress'],
                    totalPrice: order['totalPrice'],
                    orderDetails: List<Map<String, dynamic>>.from(order['orderDetails']),
                  ),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text("คำสั่งซื้อของ ${order['customerName']}"),
                subtitle: Text("ราคารวม: ${order['totalPrice'].toStringAsFixed(2)} บาท"),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
    );
  }
}
