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
          leading: startIcon != null ? Icon(startIcon) : null,
          trailing: endIcon != null ? Icon(endIcon) : null,
          title: Text(
            title,
            style: const TextStyle(
              inherit: true,
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
          onTap: onTap,
        ),
        const Divider(
          color: Colors.black26,
          height: 0,
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      height: 52,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          inherit: true,
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
