import 'package:flutter/material.dart';
import 'package:pv_analizer/screens/Home/home_screen.dart';
import 'package:pv_analizer/screens/profile/profile_screen.dart';

import '../screens/Map/map_screen.dart';

import '../screens/Login/login_screen.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget ItemDrawer(String name, IconData icon, dynamic onTap) {
      return Ink(
        child: ListTile(
          title: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
          leading: Icon(
            icon,
            color: Colors.white,
          ),
          onTap: onTap,
        ),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView(
          children: [
            DrawerHeader(
              // decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "TransMazor",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: 30,
                    child: Image.asset(
                      'assets/Icons/thunderbolt.png',
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            ItemDrawer(
              'Home',
              Icons.home,
              () {
                Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
              },
            ),
            ItemDrawer(
              "Profile",
              Icons.person,
              () {
                Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
              },
            ),
            ItemDrawer(
              "LogOut",
              Icons.logout,
              () {
                Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
