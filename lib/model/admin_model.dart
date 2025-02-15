class Admin {
  final String id;
  final String userName;
  final String name;
  final String password;

  Admin({
    required this.id,
    required this.userName,
    required this.name,
    required this.password,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['_id'] ?? '',
      userName: json['user_name'] ?? '',
      name: json['name'] ?? '',
      password: json['password'] ?? '',
    );
  }
}


