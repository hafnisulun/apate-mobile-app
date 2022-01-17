import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifikasi"),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Center(
          child: Text("Tidak ada notifikasi"),
        ),
      ),
    );
  }
}
