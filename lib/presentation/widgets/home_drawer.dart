import 'package:flutter/material.dart';
import 'package:pv_analizer/presentation/screens/profile_screen.dart';

import '../screens/map_screen.dart';

import '../screens/login_screen.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isSelected = true;

    Widget _ItemDrawer(String name, IconData icon, dynamic _onTap) {
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
          onTap: _onTap,
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
                    child: Image.asset(
                      'assets/Icons/thunderbolt.png',
                      color: Colors.white,
                    ),
                    height: 30,
                  )
                ],
              ),
            ),
            _ItemDrawer(
              'Home',
              Icons.home,
              () {
                Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
              },
            ),
            _ItemDrawer(
              "Profile",
              Icons.person,
              () {
                Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
              },
            ),
            _ItemDrawer(
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
