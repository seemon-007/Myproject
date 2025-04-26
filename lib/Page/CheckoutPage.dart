// import 'package:flutter/material.dart';
// import 'MapPage.dart';
//
// class CheckoutPage extends StatefulWidget {
//   @override
//   _CheckoutPageState createState() => _CheckoutPageState();
// }
//
// class _CheckoutPageState extends State<CheckoutPage> {
//   String? selectedAddress;
//   double? selectedLatitude;
//   double? selectedLongitude;
//
//   Future<void> _pickLocation() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const MapPage()),
//     );
//
//     if (result != null) {
//       setState(() {
//         selectedLatitude = result['latitude'];
//         selectedLongitude = result['longitude'];
//         selectedAddress = result['address'];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("ชำระเงิน")),
//       body: Column(
//         children: [
//           ListTile(
//             title: const Text("เลือกที่อยู่จัดส่ง"),
//             subtitle: Text(selectedAddress ?? "ยังไม่ได้เลือก"),
//             trailing: const Icon(Icons.map),
//             onTap: _pickLocation,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (selectedAddress != null) {
//                 print("ที่อยู่ที่เลือก: $selectedAddress");
//                 print("พิกัด: $selectedLatitude, $selectedLongitude");
//               } else {
//                 print("กรุณาเลือกที่อยู่ก่อนชำระเงิน");
//               }
//             },
//             child: const Text("ชำระเงิน"),
//           ),
//         ],
//       ),
//     );
//   }
// }
