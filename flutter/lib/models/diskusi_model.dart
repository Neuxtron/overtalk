import 'dart:convert';

class DiskusiModel {
  final int id;
  final int idUser;
  final String judul;
  final String konten;
  final DateTime createdAt;

  const DiskusiModel({
    required this.id,
    required this.idUser,
    required this.judul,
    required this.konten,
    required this.createdAt,
  });

  factory DiskusiModel.fromJson(Map<String, dynamic> json) {
    return DiskusiModel(
      id: json['id'],
      idUser: json['idUser'],
      judul: json['judul'] ?? "",
      konten: json['konten'] ?? "",
      createdAt: DateTime.parse(json['createdAt'] ?? ""),
    );
  }

  String toJson() {
    return jsonEncode({
      "id": id,
      "idUser": idUser,
      "judul": judul,
      "konten": konten,
    });
  }
}
