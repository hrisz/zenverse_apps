import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zenverse_mobile_apps/model/games_model.dart';
import 'package:zenverse_mobile_apps/services/api_services_games.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDetailPage extends StatefulWidget {
  final String gameId;

  const GameDetailPage({Key? key, required this.gameId}) : super(key: key);
  @override
  _GameDetailPageState createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  YoutubePlayerController? _controller;
  final ApiServices _dataServices = ApiServices();
  GamesModel? game;
  bool isLoading = true;

  String extractVideoId(String url) {
    Uri uri = Uri.parse(url);
    List<String> segments = uri.pathSegments;
    if (segments.length > 1 && segments[0] == 'embed') {
      return segments[1];
    }
    return '';
  }

  void _launchURL(String url) async {
  if (url.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("URL tidak tersedia")),
    );
    return;
  }

  final Uri uri = Uri.tryParse(url) ?? Uri();
  if (uri.scheme.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("URL tidak valid")),
    );
    return;
  }

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gagal membuka URL")),
    );
  }
}

  @override
  void initState() {
    super.initState();
    fetchGameDetails();
  }

  Future<void> fetchGameDetails() async {
    final fetchedGame = await _dataServices.getGameById(widget.gameId);
    if (mounted) {
      setState(() {
        game = fetchedGame;
        isLoading = false;
        if (game != null && game!.preview.isNotEmpty) {
          _controller = YoutubePlayerController(
            initialVideoId: extractVideoId(game!.preview),
            flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 66, 69, 73),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    game!.gameBanner,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                game!.gameLogo,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game!.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  game!.developer.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 114, 137, 218),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 114, 137, 218),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    game!.genre.join(', '),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _launchURL(game!.linkGames),
                          child: const Text("Download"),
                        ),
                        const SizedBox(height: 16),
                        if (_controller != null)
                          YoutubePlayer(controller: _controller!)
                        else
                          const Center(child: CircularProgressIndicator()),
                        const SizedBox(height: 16),
                        const Text(
                          'Game Description:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 114, 137, 218),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game!.description,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Developer Biography:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 114, 137, 218),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game!.developer.bio,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
