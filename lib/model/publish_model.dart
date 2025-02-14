class GamesModelPost {
  final String name;
  final String desc;
  final List<String> genre;
  final DeveloperModelPost devName;
  final String gameBanner;
  final String preview;
  final String linkGames;
  final String gameLogo;

  GamesModelPost({
    required this.name,
    required this.desc,
    required this.genre,
    required this.devName,
    required this.gameBanner,
    required this.preview,
    required this.linkGames,
    required this.gameLogo,
  });

  factory GamesModelPost.fromJson(Map<String, dynamic> json) {
    return GamesModelPost(
      name: json["name"] ?? "",
      desc: json["desc"] ?? "",
      genre: List<String>.from(json["genre"] ?? []),
      devName: DeveloperModelPost.fromJson(json["dev_name"] ?? {}),
      gameBanner: json["game_banner"] ?? "",
      preview: json["preview"] ?? "",
      linkGames: json["link_games"] ?? "",
      gameLogo: json["game_logo"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
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

class DeveloperModelPost {
  final String name;
  final String bio;

  DeveloperModelPost({
    required this.name,
    required this.bio,
  });

  factory DeveloperModelPost.fromJson(Map<String, dynamic> json) {
    return DeveloperModelPost(
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
