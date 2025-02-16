import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GameDetailPage extends StatefulWidget {
  const GameDetailPage({Key? key}) : super(key: key);
  @override
  _GameDetailPageState createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  late YoutubePlayerController _controller;
  
  String extractVideoId(String url) {
    Uri uri = Uri.parse(url);
    List<String> segments = uri.pathSegments;
    if (segments.length > 1 && segments[0] == 'embed') {
      return segments[1];
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    String embedUrl = 'https://www.youtube.com/embed/D9w97KSEAOo?rel=0&modestbranding=1';
    String videoId = extractVideoId(embedUrl);
    
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 66, 69, 73),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://fastcdn.hoyoverse.com/content-v2/plat/114197/fd9cd9607284ed46e9908d869c15ca25_1949191642527504144.jpg',
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
                          'https://fastcdn.hoyoverse.com/content-v2/plat/113653/1ebc11aa9d90c9d9aa35a3f26e7547f1_4906443086798170783.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Name Game',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Developer Game',
                            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 114, 137, 218)),
                          ),
                          const SizedBox(height: 8),
                          Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 114, 137, 218),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Action, Adventure',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Download"),
                  ),
                  const SizedBox(height: 16),
                  // YoutubePlayer(controller: _controller),
                  const SizedBox(height: 16),
                  const Text(
                    'Game Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 114, 137, 218)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Zenverse a digital distribution platform dedicated to provide immersive worlds and unforgettable experiences. Our platform is a place where you can discover, share, and play games with your friends.',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Developer Biography:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 114, 137, 218)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Zenverse a digital distribution platform dedicated to provide immersive worlds and unforgettable experiences. Our platform is a place where you can discover, share, and play games with your friends.',
                    style: TextStyle(fontSize: 14, color: Colors.white),
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
    _controller.dispose();
    super.dispose();
  }
}
