class GamesModel {
  final String id;
  final String name;
  final double rating;
  final DateTime? releaseDate; // Bisa nullable karena tidak ada di API
  final String description;
  final List<String> genre;
  final DeveloperModel developer;
  final String gameBanner;
  final String preview;
  final String linkGames;
  final String gameLogo;

  GamesModel({
    required this.id,
    required this.name,
    required this.rating,
    this.releaseDate, // Nullable
    required this.description,
    required this.genre,
    required this.developer,
    required this.gameBanner,
    required this.preview,
    required this.linkGames,
    required this.gameLogo,
  });

  factory GamesModel.fromJson(Map<String, dynamic> json) => GamesModel(
        id: json["_id"],
        name: json["name"],
        rating: (json["rating"] as num).toDouble(),
        releaseDate: json["release_date"] != null
            ? DateTime.parse(json["release_date"])
            : null, // Null jika tidak ada
        description: json["desc"],
        genre: List<String>.from(json["genre"]),
        developer: DeveloperModel.fromJson(json["dev_name"]),
        gameBanner: json["game_banner"],
        preview: json["preview"],
        linkGames: json["link_games"],
        gameLogo: json["game_logo"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "rating": rating,
        "release_date": releaseDate?.toIso8601String(), // Nullable
        "desc": description,
        "genre": genre,
        "dev_name": developer.toJson(),
        "game_banner": gameBanner,
        "preview": preview,
        "link_games": linkGames,
        "game_logo": gameLogo,
      };
}

class DeveloperModel {
  final String name;
  final String bio;

  DeveloperModel({
    required this.name,
    required this.bio,
  });

  factory DeveloperModel.fromJson(Map<String, dynamic> json) => DeveloperModel(
        name: json["name"],
        bio: json["bio"], // Perbaikan key
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "bio": bio, // Sesuai dengan key asli
      };
}
