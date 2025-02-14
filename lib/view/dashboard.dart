// screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:zenverse_mobile_apps/services/auth.dart';
import 'package:zenverse_mobile_apps/model/admin_model.dart';
import 'package:zenverse_mobile_apps/view/loginpage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Admin? admin;

  @override
  void initState() {
    super.initState();
    _checkTokenAndLoadDashboard();
  }

  
  Future<void> _checkTokenAndLoadDashboard() async {
    bool tokenExists = await ApiAuthService.isTokenAvailable();
    if (!tokenExists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyLoginpage()),
      );
    } else {
      _loadDashboard();
    }
  }

  
  Future<void> _loadDashboard() async {
    Admin? data = await ApiAuthService.getDashboardData();
    setState(() {
      admin = data;
    });
  }

 
  Future<void> _logout() async {
    bool isLoggedOut = await ApiAuthService.logout();
    if (isLoggedOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyLoginpage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: admin == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin ID: ${admin!.id}'),
                  Text('Username: ${admin!.userName}'),
                  Text('Name: ${admin!.name}'),
                ],
              ),
            ),
    );
  }
}
