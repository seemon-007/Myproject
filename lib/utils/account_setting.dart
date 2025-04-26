import 'package:flutter/material.dart';

class AccountSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const AccountSetting({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
