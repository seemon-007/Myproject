import 'package:flutter/material.dart';
import 'package:Feedme/Page/product.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'package:Feedme/Page/cart_model.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  List<Cart> _cartModel = [];

  void addToCart(Cart cart) {
    setState(() {
      _cartModel.add(cart);
    });
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.product.imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "ราคา: ${widget.product.price} บาท",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "จำนวนคงเหลือ: ${widget.product.stock} ชิ้น",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                cart.addProduct(widget.product);



                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${widget.product.productName} ถูกเพิ่มลงตะกร้า"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Text("เพิ่มลงตะกร้า"),
            ),
          ],
        ),
      ),
    );
  }
}
