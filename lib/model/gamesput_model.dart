class GamesModelPut {
  final String name;
  final double rating;
  final String desc;
  final List<String> genre;
  final DeveloperModelPut devName;
  final String gameBanner;
  final String preview;
  final String linkGames;
  final String gameLogo;

  GamesModelPut({
    required this.name,
    required this.desc,
    required this.rating,
    required this.genre,
    required this.devName,
    required this.gameBanner,
    required this.preview,
    required this.linkGames,
    required this.gameLogo,
  });

  factory GamesModelPut.fromJson(Map<String, dynamic> json) {
    return GamesModelPut(
      name: json["name"] ?? "",
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
      desc: json["desc"] ?? "",
      genre: List<String>.from(json["genre"] ?? []),
      devName: DeveloperModelPut.fromJson(json["dev_name"] ?? {}),
      gameBanner: json["game_banner"] ?? "",
      preview: json["preview"] ?? "",
      linkGames: json["link_games"] ?? "",
      gameLogo: json["game_logo"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "rating": rating,
      "desc": desc,
      "genre": genre,
      "dev_name": devName.toJson(),
      "game_banner": gameBanner,
      "preview": preview,
      "link_games": linkGames,
      "game_logo": gameLogo,
    };
  }
}

class DeveloperModelPut {
  final String name;
  final String bio;

  DeveloperModelPut({
    required this.name,
    required this.bio,
  });

  factory DeveloperModelPut.fromJson(Map<String, dynamic> json) {
    return DeveloperModelPut(
      name: json["name"] ?? "",
      bio: json["bio"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "bio": bio,
    };
  }
}
