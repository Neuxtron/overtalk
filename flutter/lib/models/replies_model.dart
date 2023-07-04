import 'dart:convert';

class Replies {
  final int idReplies;
  final int idDiskusi;
  final int idUser;
  final String reply;
  List upVotes;
  List downVotes;
  final DateTime createdAt;

  Replies(
    this.idReplies,
    this.idDiskusi,
    this.idUser,
    this.reply,
    this.upVotes,
    this.downVotes,
    this.createdAt,
  );

  factory Replies.fromJson(Map<String, dynamic> json) {
    return Replies(
      json["id"],
      json["idDiskusi"],
      json["idUser"],
      json["reply"],
      json["upVotes"] == null ? [] : jsonDecode(json["upVotes"]),
      json["downVotes"] == null ? [] : jsonDecode(json["downVotes"]),
      DateTime.parse(json["createdAt"]),
    );
  }
}
