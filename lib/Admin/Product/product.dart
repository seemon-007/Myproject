import 'package:flutter/material.dart';
import '../BasePage.dart';
import 'AddHomepage/add_homepage.dart';
import 'Order/order.dart';
import 'ProductList/productlist.dart';
import 'ShoppingSetting/shopping_setting.dart';
import 'product_setting.dart';


class ProductPageseting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasePageadmin(
      index: 0,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(title: Text('Product'), backgroundColor: Colors.blue),
            Padding(
              padding: const EdgeInsets.all(Sizes.defoult),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ProductSetting(
                    icon: Icons.add_box_outlined,
                    title: 'จัดการข่าวสาร(หน้าHome)',
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => AddHomePage()));
                    },
                    backgroundColor: Colors.black12,
                    borderRadius: 15,
                  ),
                  SizedBox(height: 20),
                  ProductSetting(
                    icon: Icons.shopping_bag_outlined,
                    title: 'รายการสินค้า',
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => ProductlistPage()));
                    },
                    backgroundColor: Colors.black12,
                    borderRadius: 15,
                  ),
                  SizedBox(height: 20),
                  ProductSetting(
                    icon: Icons.paste,
                    title: 'ออเดอร์',
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => OrderPage()));
                    },
                    backgroundColor: Colors.black12,
                    borderRadius: 15,
                  ),
                  SizedBox(height: 20),
                  ProductSetting(
                    icon: Icons.local_shipping_outlined,
                    title: 'กำหนดค่าส่ง',
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => ShippingSettingPage()));
                    },
                    backgroundColor: Colors.black12,
                    borderRadius: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Sizes {
  static const double defoult = 20.0;
}
