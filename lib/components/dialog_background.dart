import 'package:flutter/material.dart';

class DialogBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: const ModalBarrier(
        dismissible: false,
        color: Colors.black,
      ),
    );
  }
}
