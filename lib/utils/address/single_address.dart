import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TSingAddress extends StatelessWidget {
  const TSingAddress({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.onTap
  });

  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.black,),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.titleMedium),
      trailing: trailing,
      onTap: onTap,

    );
  }
}

