// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'BasePage.dart';
// import 'package:Feedme/constants/config.dart';
// import 'package:Feedme/Page/CartPage.dart';
// import 'package:Feedme/Page/product_list.dart';
// import 'MainScreen.dart';
// class HomePage extends StatelessWidget {
//   Future<List<String>> fetchImageUrls() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://${Config.BASE_IP}:${Config.BASE_PORT}/api/products/latest-images'),
//       );
//
//       print("API Status Code: ${response.statusCode}");
//       print("API Response: ${response.body}");
//
//       if (response.statusCode == 200) {
//
//         final data = json.decode(response.body);
//         return List<String>.from(data['images']);
//       } else {
//         throw Exception('Failed to load images');
//       }
//     } catch (e) {
//       print("Error fetching images: $e");
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // return BasePage(
//     //   index: 0,
//     //   body: Scaffold(
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Home",
//             style: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความเป็นสีขาว
//           ),
//           backgroundColor: Colors.blue, // สีพื้นหลังของ AppBar
//           elevation: 0,
//           centerTitle: true,// เอาเงาของ AppBar ออก
//         ),
//         body: FutureBuilder<List<String>>(
//           future: fetchImageUrls(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.hasData) {
//               final images = snapshot.data!;
//               return GridView.builder(
//                 padding: EdgeInsets.all(10),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // 2 คอลัมน์
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: 6, // แสดง 6 รูป
//                 itemBuilder: (context, index) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Colors.blue, width: 2),
//                       color: Colors.grey[200],
//                     ),
//                     child: images.length > index
//                         ? ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(
//                         images[index],
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Icon(Icons.error, size: 50);
//                         },
//                       ),
//                     )
//                         : Center(
//                       child: Text(
//                         'ยังไม่มีโปรโมชั่น',
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return Center(child: Text('No images available'));
//             }
//           },
//         ),
//       );
//     // );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Feedme/constants/config.dart';

class HomePage extends StatelessWidget {
  Future<List<String>> fetchImageUrls() async {
    try {
      final response = await http.get(
        Uri.parse('http://${Config.BASE_IP}:${Config.BASE_PORT}/api/products/latest-images'),
      );

      print("API Status Code: ${response.statusCode}");
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['images']);
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print("Error fetching images: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: true,
        ),
        Expanded(
          child: FutureBuilder<List<String>>(
            future: fetchImageUrls(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final images = snapshot.data!;
                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue, width: 2),
                        color: Colors.grey[200],
                      ),
                      child: images.length > index
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, size: 50);
                          },
                        ),
                      )
                          : Center(
                        child: Text(
                          'ยังไม่มีโปรโมชั่น',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('No images available'));
              }
            },
          ),
        ),
      ],
    );
  }
}