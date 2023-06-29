import 'dart:convert';

class UserModel {
  final int id;
  final String email;
  final String nama;
  final List bookmarks;

  UserModel(
    this.id,
    this.email,
    this.nama,
    this.bookmarks,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print(jsonDecode(json["bookmarks"]).runtimeType);
    print(jsonDecode(json["bookmarks"]));
    return UserModel(
      json["id"],
      json["email"],
      json["nama"],
      jsonDecode(json["bookmarks"]),
    );
  }
}
