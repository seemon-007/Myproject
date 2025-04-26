// import 'dart:convert';
// import 'package:Feedme/constants/config.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'BasePage.dart';
// import 'product.dart';
// import 'cart_provider.dart';
// import 'ProductCard.dart'; //  นำเข้า ProductCard
// import 'MainScreen.dart';
//
// class ProductListPage extends StatefulWidget {
//   @override
//   _ProductListPageState createState() => _ProductListPageState();
// }
//
// class _ProductListPageState extends State<ProductListPage> {
//   List<Product> products = [];
//   List<String> imageUrls = [];
//   bool isLoading = true;
//   String searchQuery = "";
//   String selectedCategory = "All";
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }
//
//   Future<void> fetchProducts() async {
//     final String apiUrl = "http://${Config.BASE_IP}:${Config.BASE_PORT}/api/products";
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       print(" API Status Code: ${response.statusCode}");
//       if (response.statusCode == 200) {
//         List<dynamic> jsonData = json.decode(response.body);
//         print(" API Response Data:");
//         print(" Raw API Response: ${response.body}");
//         setState(() {
//           products = jsonData.map((json) => Product.fromJson(json)).toList();
//           isLoading = false;
//         });
//         print(" Product count: ${products.length}");
//       } else {
//         throw Exception(" Failed to load products: ${response.statusCode}");
//       }
//     } catch (error) {
//       print(" Error fetching products: $error");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var cart = Provider.of<CartProvider>(context);
//
//     List<Product> filteredProducts = products.where((product) {
//       return (selectedCategory == "All" || product.category == selectedCategory) &&
//           (searchQuery.isEmpty || product.productName.toLowerCase().contains(searchQuery.toLowerCase()));
//     }).toList();
//
//     // return BasePage(
//     //   index: 1,
//     //   body: Scaffold(
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Product",style: TextStyle(color: Colors.white),),
//           backgroundColor: Colors.blue,
//           centerTitle: true,
//           actions: [
//             Stack(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.shopping_cart),
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/Cart');
//                   },
//                 ),
//                 // if (cart.itemCount > 0)
//                 //   Positioned(
//                 //     right: 0,
//                 //     child: CircleAvatar(
//                 //       radius: 10,
//                 //       backgroundColor: Colors.red,
//                 //       child: Text(
//                 //         cart.itemCount.toString(),
//                 //         style: TextStyle(fontSize: 12, color: Colors.white),
//                 //       ),
//                 //     ),
//                 //   ),
//               ],
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white10,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     //  ช่องค้นหา
//                     Expanded(
//                       child: TextField(
//                         onChanged: (value) {
//                           setState(() {
//                             searchQuery = value;
//                           });
//                         },
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//                           hintText: "ค้นหาสินค้า...",
//                           prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 8),
//
//
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                       child: DropdownButton<String>(
//                         value: selectedCategory,
//                         underline: SizedBox(),
//                         icon: Icon(Icons.arrow_drop_down, color: Colors.white),
//                         dropdownColor: Colors.white12,
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                         items: [
//                           DropdownMenuItem(value: "All", child: Text("ทั้งหมด")),
//                           DropdownMenuItem(value: "สุนัข", child: Text("สุนัข")),
//                           DropdownMenuItem(value: "แมว", child: Text("แมว")),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCategory = value!;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : RefreshIndicator(
//                 onRefresh: fetchProducts,
//                 child: filteredProducts.isEmpty
//                     ? ListView(
//                   children: [
//                     SizedBox(height: 50),
//                     Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey),
//                           SizedBox(height: 10),
//                           Text(
//                             "ยังไม่ได้เพิ่มสินค้า",
//                             style: TextStyle(fontSize: 18, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )
//                     : ListView.builder(
//                   itemCount: filteredProducts.length,
//                   itemBuilder: (context, index) {
//                     final product = filteredProducts[index];
//
//                     return ProductCard(product: product); //  ใช้ ProductCard
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       // ),
//     // );
//     );
//   }
// }

import 'dart:convert';
import 'package:Feedme/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'cart_provider.dart';
import 'ProductCard.dart';
import 'MainScreen.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];
  List<String> imageUrls = [];
  bool isLoading = true;
  String searchQuery = "";
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final String apiUrl = "http://${Config.BASE_IP}:${Config.BASE_PORT}/api/products";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print(" API Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print(" API Response Data:");
        print(" Raw API Response: ${response.body}");
        setState(() {
          products = jsonData.map((json) => Product.fromJson(json)).toList();
          isLoading = false;
        });
        print(" Product count: ${products.length}");
      } else {
        throw Exception(" Failed to load products: ${response.statusCode}");
      }
    } catch (error) {
      print(" Error fetching products: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);

    List<Product> filteredProducts = products.where((product) {
      return (selectedCategory == "All" || product.category == selectedCategory) &&
          (searchQuery.isEmpty || product.productName.toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Product", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    MainScreen.changeTab(context, 2);
                  }
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        hintText: "ค้นหาสินค้า...",
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      dropdownColor: Colors.white12,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      items: [
                        DropdownMenuItem(value: "All", child: Text("ทั้งหมด")),
                        DropdownMenuItem(value: "สุนัข", child: Text("สุนัข")),
                        DropdownMenuItem(value: "แมว", child: Text("แมว")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: fetchProducts,
              child: filteredProducts.isEmpty
                  ? ListView(
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "ยังไม่ได้เพิ่มสินค้า",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}