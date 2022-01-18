import 'package:flutter/material.dart';

class AptFlatButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  AptFlatButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: TextButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        primary: Colors.white,
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }
}
