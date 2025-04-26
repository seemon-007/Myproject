import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Feedme/constants/config.dart';
class User {
  final int customerId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String role;

  User({
    required this.customerId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      customerId: json['customer_id'],
      name: json['name'],
      email: json['Email'],
      phone: json['Phone'],
      address: json['address'] ?? "ไม่ระบุที่อยู่",
      role: json['role'],
    );
  }
}

class UserService {
  static const String apiUrl = "http://${Config.BASE_IP}:${Config.BASE_PORT}/api/users";

  Future<User> fetchUserById(int id) async {
    final response = await http.get(Uri.parse("$apiUrl/$id"));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception("User not found");
    }
  }
}
