import 'package:flutter/material.dart';
import 'package:zenverse_mobile_apps/services/auth.dart';
import 'package:zenverse_mobile_apps/model/admin_model.dart';
import 'package:zenverse_mobile_apps/model/games_model.dart';
import 'package:zenverse_mobile_apps/view/admin/updatepage.dart';
import 'package:zenverse_mobile_apps/view/loginpage.dart';
import 'package:zenverse_mobile_apps/services/api_services_games.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Admin? admin;
  List<GamesModel> games = [];
  bool isLoading = true;
  final ApiServices _dataServices = ApiServices();
  int _page = 0;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _checkTokenAndLoadDashboard();
  }

  Future<void> _fetchGames() async {
    try {
      List<GamesModel> gameList = await _dataServices.getAllGamesHomepage(page: _page, limit: _limit);
      setState(() {
        games.addAll(gameList);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching games: $e");
    }
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
      _fetchGames();
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

  void _loadMoreGames() {
    setState(() {
      _page++;
    });
    _fetchGames();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      games.clear();  
      _page = 0; 
    });
    await _fetchGames();  // Fetch fresh data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
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
                const Spacer(),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Dashboard",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          if (admin != null)
                            Text(
                              "Welcome, ${admin!.name}",
                              style: const TextStyle(fontSize: 16, color: Colors.white70),
                            ),
                        ],
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: RefreshIndicator(
                      onRefresh: _refreshData, 
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('ID', style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text('Name', style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text('Developer', style: TextStyle(color: Colors.black))),
                                  DataColumn(label: Text('Actions', style: TextStyle(color: Colors.black))),
                                ],
                                rows: games.map((game) => DataRow(cells: [
                                  DataCell(Text(game.id, style: const TextStyle(color: Colors.black))),
                                  DataCell(Text(game.name, style: const TextStyle(color: Colors.black))),
                                  DataCell(Text(game.developer.name, style: const TextStyle(color: Colors.black))),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MyUpdatePage(gameId: game.id),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {},
                                      ),
                                    ],
                                  )),
                                ])).toList(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Button for Load More
                            ElevatedButton(
                              onPressed: _loadMoreGames,
                              child: const Text("Load More"),
                            ),
                          ],
                        ),
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
