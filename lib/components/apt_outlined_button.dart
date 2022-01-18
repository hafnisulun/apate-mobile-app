import 'package:flutter/material.dart';

class AptOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color color;

  AptOutlinedButton({
    required this.onPressed,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(text),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: color),
        primary: color,
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }
}
