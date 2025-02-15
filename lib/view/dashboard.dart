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
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 80,
            color: Colors.black87,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  height: 35,
                  width: 35,
                  child: Image.asset('assets/icon/blue-logo.png'),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {},
                ),
                const Spacer(), // Spacer untuk menempatkan logout di bawah
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: _logout,
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: const Color.fromARGB(255, 66, 69, 73),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Dashboard", style: TextStyle(fontSize: 20, color: Colors.white)),
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      )
                    ],
                  ),
                ),

                // Table Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Name', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Developer', style: TextStyle(color: Colors.white))),
                          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white))),
                        ],
                        rows: List.generate(5, (index) => DataRow(cells: [
                          DataCell(Text('${index + 1}', style: const TextStyle(color: Colors.white))),
                          DataCell(Text('Name ${index + 1}', style: const TextStyle(color: Colors.white))),
                          DataCell(Text('Developer ${index + 1}', style: const TextStyle(color: Colors.white))),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {},
                              ),
                            ],
                          )),
                        ])),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
