import 'package:flutter/material.dart';
import 'package:zenverse_mobile_apps/view/homepage.dart';
import 'package:zenverse_mobile_apps/view/loginpage.dart';
import 'package:zenverse_mobile_apps/view/publishpage.dart';

class DynamicBottomNavbar extends StatefulWidget {
  const DynamicBottomNavbar({super.key});
  @override
  State<DynamicBottomNavbar> createState() => _DynamicBottomNavbarState();
}

class _DynamicBottomNavbarState extends State<DynamicBottomNavbar> {
  int _currentPageIndex = 0;
  final List<Widget> _pages = <Widget>[
    const MyHomepage(),
    const MyPublishpage(),
    const MyLoginpage(),
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_currentPageIndex]
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.games_rounded),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Publish',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login_rounded),
            label: 'Login',
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 54, 57, 62),
        selectedItemColor: const Color.fromARGB(255, 114, 137, 218),
        unselectedItemColor: Colors.white,
      ),
    );
  }
}