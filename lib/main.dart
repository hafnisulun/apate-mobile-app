import 'package:apate/env.dart';
import 'package:apate/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("[MyApp] [build] currentUser: ${FirebaseAuth.instance.currentUser}");
    return MaterialApp(
      title: Env.APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: FirebaseAuth.instance.currentUser != null
      //     ? HomeScreen()
      //     : LoginScreen(),
      home: LoginScreen(),
    );
  }
}
