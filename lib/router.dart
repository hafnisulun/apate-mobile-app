import 'package:apate/screens/screens.dart';
import 'package:flutter/material.dart';

const String homeRoute = '/';
const String loginRoute = '/login';
const String shopRoute = '/shop';
const String merchantRoute = '/merchant';
const String checkoutRoute = '/checkout';
const String notificationsRoute = '/notifications';
const String accountRoute = '/account';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case shopRoute:
        return MaterialPageRoute(
            builder: (_) => ShopScreen()); // case merchantRoute:
      //   return MaterialPageRoute(builder: (_) => MerchantScreen());
      // case checkoutRoute:
      //   return MaterialPageRoute(builder: (_) => CheckoutScreen());
      case notificationsRoute:
        return MaterialPageRoute(builder: (_) => NotificationsScreen());
      case accountRoute:
        return MaterialPageRoute(builder: (_) => AccountScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
