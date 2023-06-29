class Replies {
  final int idReplies;
  final int idDiskusi;
  final int idUser;
  final String reply;
  final DateTime createdAt;

  Replies(
    this.idReplies,
    this.idDiskusi,
    this.idUser,
    this.reply,
    this.createdAt,
  );

  factory Replies.fromJson(Map<String, dynamic> json) {
    return Replies(
      json["id"],
      json["idDiskusi"],
      json["idUser"],
      json["reply"],
      DateTime.parse(json["createdAt"]),
    );
  }
}
