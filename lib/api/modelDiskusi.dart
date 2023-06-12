class Diskusi {
  final String id;
  final String pembuka;
  final String judul;
  final String konten;
  final List replies;
  final DateTime createdAt;

  const Diskusi({
    required this.id,
    required this.pembuka,
    required this.judul,
    required this.konten,
    required this.replies,
    required this.createdAt,
  });

  factory Diskusi.fromJson(Map<String, dynamic> json) {
    return Diskusi(
      id: json['id'],
      pembuka: json['pembuka'],
      judul: json['judul'],
      konten: json['konten'],
      replies: json['replies'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
