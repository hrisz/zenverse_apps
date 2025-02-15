import 'package:flutter/material.dart';
import 'package:zenverse_mobile_apps/model/games_model.dart';
import 'package:zenverse_mobile_apps/services/api_services_games.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomepage> {
  final ApiServices _dataServices = ApiServices();
  final List<GamesModel> _homeGames = [];
  List<GamesModel> _topRatedGames = [];
  String _searchQuery = '';
  List<GamesModel> _searchResults = [];
  int _page = 0;
  final int _limit = 10;
  bool _isLoading = false;

   @override
  void initState() {
    super.initState();
    _fetchGamesData();
    _fetchTopRatedGames(); 
  }

  void _fetchGamesData() async {
    setState(() {
      _isLoading = true;
    });
    final gamesData =
        await _dataServices.getAllGamesHomepage(page: _page, limit: _limit);
    setState(() {
      _homeGames.addAll(gamesData);
      _isLoading = false;
    });
  }

  void _fetchTopRatedGames() async {
    final topRatedData = await _dataServices.getGamesByRating(9.0);
    if (topRatedData != null) {
      setState(() {
        _topRatedGames = topRatedData;
      });
    }
  }

  void _searchGames(String query) async {
    final searchResults = await _dataServices.getGamesByName(query);
    if (searchResults != null) {
      setState(() {
        _searchResults = searchResults;
      });
    }
  }

  @override
  void dispose() {
    _homeGames.clear();
    _topRatedGames.clear();
    _searchResults.clear();
    super.dispose();
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Game'),
          content: TextField(
            onChanged: (value) {
              _searchQuery = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter game name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _searchGames(_searchQuery);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _loadMoreGames() {
    setState(() {
      _page++;
    });
    _fetchGamesData();
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
            onPressed: () {
              showSearchDialog(context);
            },
          ),
          if (_searchResults.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchResults = [];
                });
              },
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
          if (_searchResults.isEmpty)
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
                      game.gameBanner,
                      game.gameLogo,
                      game.rating,
                    );
                  },
                ),
              ),
            ),
          // Grid aplikasi atau hasil pencarian
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
              itemCount: _searchResults.isNotEmpty
                  ? _searchResults.length
                  : _homeGames.length,
              itemBuilder: (context, index) {
                final game = _searchResults.isNotEmpty
                    ? _searchResults[index]
                    : _homeGames[index];
                return appCard(
                  game.name,
                  game.gameBanner,
                  game.developer.name,
                );
              },
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (!_isLoading && _homeGames.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                // Memusatkan ElevatedButton
                child: ElevatedButton(
                  onPressed: _loadMoreGames,
                  child: const Text('Load More'),
                ),
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
