import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final IconData? startIcon;
  final IconData? endIcon;

  const MenuItemWidget({
    required this.title,
    required this.onTap,
    this.startIcon,
    this.endIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading:
              startIcon != null ? Icon(startIcon, color: Colors.black) : null,
          trailing: endIcon != null ? Icon(endIcon, color: Colors.black) : null,
          title: Text(
            title,
            style: const TextStyle(
              inherit: true,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          onTap: onTap,
          tileColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        const Divider(
          color: Colors.black26,
          height: 1,
          endIndent: 16,
          indent: 16,
        ),
      ],
    );
  }
}

class TitleItemWidget extends StatelessWidget {
  final String title;

  const TitleItemWidget({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 52,
      color: Colors.grey[200],
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          inherit: true,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
