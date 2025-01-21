import 'package:flutter/material.dart';

class MyHomepage extends StatelessWidget {
  const MyHomepage({Key? key}) : super(key: key);

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
                itemCount: 10,
                itemBuilder: (context, index) {
                  return appHorizontalCard(
                    context,
                    'Zenverse Apps',
                    'assets/img/default-banner.png',
                    'assets/img/default-logo.png',
                    8.7,
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
              itemCount: 8, // Number of cards
              itemBuilder: (context, index) {
                return appCard(
                    'Zen_App $index', Icons.apps, 'Developer $index');
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget kartu aplikasi
  Widget appCard(String name, IconData icon, String developer) {
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
            child: Center(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  icon,
                  size: 30,
                  color: const Color.fromARGB(255, 114, 137, 218),
                ),
              ),
            ),
          ),
          // Text and Rating Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  developer,
                  style: const TextStyle(fontSize: 12),
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
    String coverImage,
    String iconImage,
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
                child: Image.asset(
                  coverImage,
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
                      child: Image.asset(
                        iconImage,
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
