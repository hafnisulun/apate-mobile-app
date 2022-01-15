import 'package:flutter/material.dart';

class LaunchScreen extends StatelessWidget {
  final String? error;

  LaunchScreen({
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Body(error: error),
    );
  }
}

class Body extends StatelessWidget {
  final String? error;

  Body({
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (error == null) {
      return Container();
    } else {
      return Center(
        child: Text(
          error!,
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
}
