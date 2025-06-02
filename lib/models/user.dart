class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  String? profilePicturePath;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profilePicturePath,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? profilePicturePath,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profile_picture': profilePicturePath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profilePicturePath: map['profile_picture'],
    );
  }
}
