class GameModelPostAdmin {
  final String name;
  final double rating;
  final String desc;
  final List<String> genre;
  final DeveloperModelPostAdmin devName;
  final String gameBanner;
  final String preview;
  final String linkGames;
  final String gameLogo;

  GameModelPostAdmin({
    required this.name,
    required this.rating,
    required this.desc,
    required this.genre,
    required this.devName,
    required this.gameBanner,
    required this.preview,
    required this.linkGames,
    required this.gameLogo,
  });

  factory GameModelPostAdmin.fromJson(Map<String, dynamic> json) {
    return GameModelPostAdmin(
      name: json["name"] ?? "",
      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
      desc: json["desc"] ?? "",
      genre: List<String>.from(json["genre"] ?? []),
      devName: DeveloperModelPostAdmin.fromJson(json["dev_name"] ?? {}),
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

class DeveloperModelPostAdmin {
  final String name;
  final String bio;

  DeveloperModelPostAdmin({
    required this.name,
    required this.bio,
  });

  factory DeveloperModelPostAdmin.fromJson(Map<String, dynamic> json) {
    return DeveloperModelPostAdmin(
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
