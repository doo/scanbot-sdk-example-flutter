import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const FilterButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          backgroundColor: Colors.grey[800],
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text),
        ),
      ),
    );
  }
}
