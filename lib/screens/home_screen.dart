import 'package:apate/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 0),
      screens: _buildScreens(),
      items: _buildNavBarItems(context),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      hideNavigationBar: false,
      decoration: NavBarDecoration(
        border: Border(
            top: BorderSide(
          color: Colors.grey[300]!,
        )),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }

  List<PersistentBottomNavBarItem> _buildNavBarItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_basket),
        title: "Belanja",
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notifications),
        title: ("Notifikasi"),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Akun"),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      ShopScreen(),
      NotificationsScreen(),
      AccountScreen(),
    ];
  }
}
