import 'dart:convert';

class UserModel {
  final int id;
  final String email;
  final String nama;
  String fotoUrl;
  List bookmarks;
  String? token;

  UserModel(
    this.id,
    this.email,
    this.nama,
    this.fotoUrl,
    this.bookmarks,
    this.token,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json["id"],
      json["email"],
      json["nama"],
      json["fotoUrl"],
      jsonDecode(json["bookmarks"]),
      json["token"],
    );
  }

  String toJson() {
    return jsonEncode({
      "id": id,
      "nama": nama,
      "email": email,
      "fotoUrl": fotoUrl,
      "bookmarks": bookmarks,
      "token": token,
    });
  }
}
