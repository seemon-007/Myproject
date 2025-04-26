import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final String customerName;
  final String deliveryAddress;
  final double totalPrice;
  final List<Map<String, dynamic>> orderDetails;

  const OrderDetailsPage({
    required this.customerName,
    required this.deliveryAddress,
    required this.totalPrice,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดคำสั่งซื้อ'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ชื่อผู้สั่ง: $customerName",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "ที่อยู่จัดส่ง: $deliveryAddress",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "ราคารวม: ${totalPrice.toStringAsFixed(2)} บาท",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "รายละเอียดคำสั่งซื้อ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orderDetails.length,
                itemBuilder: (context, index) {
                  final item = orderDetails[index];
                  final imageUrl = item['image'] ?? 'https://via.placeholder.com/50';

                  return ListTile(
                    leading: imageUrl.startsWith('http')
                        ? Image.network(imageUrl, width: 50, height: 50, errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                    })
                        : Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    title: Text(item['name']),
                    subtitle: Text("จำนวน: ${item['quantity']}"),
                    trailing: Text("${item['price']} บาท"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
