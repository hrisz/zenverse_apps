import 'package:flutter/material.dart';
import 'package:zenverse_mobile_apps/model/games_model.dart';
import 'package:zenverse_mobile_apps/services/api_services.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomepage> {
  final ApiServices _dataServices = ApiServices();
  List<GamesModel> _homeGames = [];
  List<GamesModel> _topRatedGames = [];

  @override
  void initState() {
    super.initState();
    _fetchGamesData();
    _fetchTopRatedGames();
  }

  void _fetchGamesData() async {
    final gamesData = await _dataServices.getAllGamesHomepage();
    if (gamesData != null) {
      setState(() {
        _homeGames = gamesData;
      });
    }
  }

  void _fetchTopRatedGames() async {
    final topRatedData = await _dataServices
        .getGamesByRating(9.0); 
    if (topRatedData != null) {
      setState(() {
        _topRatedGames = topRatedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icon/blue-logo.png',
          height: 30,
        ),
        backgroundColor: const Color.fromARGB(255, 54, 57, 62),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 125,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _topRatedGames.length,
                itemBuilder: (context, index) {
                  final game = _topRatedGames[index];
                  return appHorizontalCard(
                    context,
                    game.name,
                    game.gameBanner, // Gambar sampul
                    game.gameLogo, // Placeholder jika null
                    game.rating,
                  );
                },
              ),
            ),
          ),
          // Grid aplikasi
          Expanded(
            child: GridView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: _homeGames.length, // Number of cards
              itemBuilder: (context, index) {
                final game = _homeGames[index];
                return appCard(game.name, game.gameBanner, game.developer.name);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget kartu aplikasi
  Widget appCard(String name, String gameBanner, String developer) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Section
          Container(
            height: 100, // Fixed height for the upper section
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 114, 137, 218), // Grey background
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: Image.network(
                gameBanner,
                fit: BoxFit.cover,
                height: 100,
                width: double.infinity,
              ),
            ),
          ),
          // Text and Rating Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // Batas 1 baris
                ),
                const SizedBox(height: 4),
                Text(
                  developer,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey, // Warna teks lebih lembut
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // Batas 1 baris
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget appHorizontalCard(
    BuildContext context,
    String name,
    String gameBanner,
    String gameLogo,
    double rating,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          maxHeight: 80,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gambar cover
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  gameBanner,
                  width: double.infinity,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ikon aplikasi
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        gameLogo,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Informasi aplikasi
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                rating.toString(),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
