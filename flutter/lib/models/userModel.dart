class UserModel {
  final String id;
  final String email;
  final String nama;
  final String password;
  final List bookmarks;

  UserModel(
    this.id,
    this.email,
    this.nama,
    this.password,
    this.bookmarks,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json["id"],
      json["email"],
      json["nama"],
      json["password"],
      json["bookmarks"],
    );
  }
}
