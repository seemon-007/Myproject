import 'package:flutter/material.dart';

class ProductSetting extends StatelessWidget {
  const ProductSetting({
    Key? key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.backgroundColor = Colors.white, // Default color
    this.borderRadius = 10.0, // Default border radius
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor, // Set the background color
        borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
      ),
      child: ListTile(
        leading: Icon(icon, size: 20, color: Colors.black),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
