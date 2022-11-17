import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;
  final IconData? startIcon;
  final IconData? endIcon;

  MenuItemWidget(this.title, {this.onTap, this.startIcon, this.endIcon});

  @override
  Widget build(BuildContext context) {
    var listTile = ListTile(
      leading: startIcon != null ? Icon(startIcon) : null,
      trailing: endIcon != null ? Icon(endIcon) : null,
      title: Text(
        title,
        style: const TextStyle(
            inherit: true, fontSize: 16.0, color: Colors.black87),
      ),
      onTap: onTap,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        listTile,
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

  TitleItemWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      height: 52,
      child: Text(
        title.toUpperCase(),
        style:
            const TextStyle(inherit: true, fontSize: 16.0, color: Colors.black),
      ),
    );
  }
}
