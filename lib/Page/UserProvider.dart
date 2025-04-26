import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? _customerId;
  String? _name;
  String? _email;
  String? _phone;
  String? _address;
  String? _role;
  String? _token;

  // Getter
  int? get customerId => _customerId;
  String? get name => _name;
  String? get email => _email;
  String? get phone => _phone;
  String? get address => _address;
  String? get role => _role;
  String? get token => _token;

  // Setter
  void setUserData(Map<String, dynamic> userData) {
    _customerId = userData["customer_id"];
    _name = userData["name"];
    _email = userData["Email"];
    _phone = userData["Phone"];
    _address = userData["address"];
    _role = userData["role"];
    _token = userData["token"];
    notifyListeners();
  }
}
