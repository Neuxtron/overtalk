class User {
  final String id;
  final String email;
  final String nama;
  final String password;
  final List bookmarks;

  User(
    this.id,
    this.email,
    this.nama,
    this.password,
    this.bookmarks,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json["id"],
      json["email"],
      json["nama"],
      json["password"],
      json["bookmarks"],
    );
  }
}
