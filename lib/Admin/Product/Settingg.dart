import 'package:flutter/material.dart';

class Settingg extends StatelessWidget {
  const Settingg({
    super.key,

    required this.title,

    this.trailing,
    this.onTap
  });


  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(

      title: Text(title, style: Theme.of(context).textTheme.titleMedium),

      trailing: trailing,
      onTap: onTap,
    );
  }
}