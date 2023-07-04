// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:overtalk/models/diskusi_model.dart';
import 'package:overtalk/models/replies_model.dart';
import 'package:overtalk/models/user_model.dart';

class Repository {
  final _baseUrl = "http://192.168.18.14:3000";
  // final _baseUrl = "http://192.168.43.135:3000";

  //--- Ambil Satu User ---//
  Future getUser(String email) async {
    try {
      final response =
          await http.get(Uri.parse("$_baseUrl/users/single?email=$email"));

      if (response.statusCode == 200) {
        List jsonData = jsonDecode(response.body);
        UserModel dataUser = jsonData.map((e) => UserModel.fromJson(e)).first;
        return dataUser;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //--- Ambil List Diskusi ---//
  Future getDiskusi() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/diskusi"));

      if (response.statusCode == 200) {
        List jsonData = jsonDecode(response.body);
        List<DiskusiModel> dataDiskusi =
            jsonData.map((e) => DiskusiModel.fromJson(e)).toList();
        return dataDiskusi;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //--- Daftar User Baru ---//
  Future daftar(String nama, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/users"),
        headers: <String, String>{"content-type": "application/json"},
        body: jsonEncode({
          "nama": nama,
          "email": email,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //--- Ambil Semua Users ---//
  Future getUsers() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/users"));

      if (response.statusCode == 200) {
        List jsonData = jsonDecode(response.body);
        List<UserModel> dataUser =
            jsonData.map((e) => UserModel.fromJson(e)).toList();
        return dataUser;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //--- Buka Diskusi ---//
  Future bukaDiskusi(DiskusiModel model) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/diskusi"),
        headers: <String, String>{"content-type": "application/json"},
        body: model.toJson(),
      );

      if (response.statusCode == 200) {
        Map jsonData = jsonDecode(response.body);
        int id = jsonData["data"]["id"];
        return id;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //--- Ambil Replies ---//
  Future getReplies(int idDiskusi) async {
    try {
      final response =
          await http.get(Uri.parse("$_baseUrl/replies?id_diskusi=$idDiskusi"));

      if (response.statusCode == 200) {
        List jsonData = jsonDecode(response.body);
        List<Replies> dataReplies =
            jsonData.map((e) => Replies.fromJson(e)).toList();

        return dataReplies;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //--- Tambah Reply ---//
  Future reply(
      DiskusiModel diskusi, UserModel user, String reply, String? token) async {
    if (token != null) notify(token, diskusi, user, reply);

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/replies"),
        headers: <String, String>{"content-type": "application/json"},
        body: jsonEncode({
          "idDiskusi": diskusi.id,
          "idUser": user.id,
          "reply": reply,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future vote(Replies reply) async {
    final response = await http.put(
      Uri.parse("$_baseUrl/replies"),
      headers: <String, String>{"content-type": "application/json"},
      body: jsonEncode({
        "id": reply.idReplies,
        "upVotes": reply.upVotes,
        "downVotes": reply.downVotes,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //--- Update User ---//
  Future updateUser(UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/users"),
        headers: <String, String>{"content-type": "application/json"},
        body: user.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //--- Hapus Akun ---//
  Future hapusAkun(String email) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/users"),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //--- Update Bookmarks ---//
  // Future updateBookmarks(String email, List bookmarks) async {
  //   try {
  //     final response = await http.put(
  //       Uri.parse("$_baseUrl/users"),
  //       headers: <String, String>{"content-type": "application/json"},
  //       body: jsonEncode({
  //         "email": email,
  //         "bookmarks": bookmarks,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  //--- Hapus Forum ---//
  Future hapusDiskusi(String id) async {
    try {
      final response = await http.delete(Uri.parse("$_baseUrl/diskusi/$id"));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future notify(
      String token, DiskusiModel diskusi, UserModel user, String reply) async {
    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: {
        "Authorization":
            "key=AAAAWz_qkXM:APA91bFNvFzVp6ZlsgYdPA9WKJFf0GhMnAokWMWOjdNX4pJml7GXWPfQ_CEjSZ5ltgXMLwncJUrmXt8ReL0WQLYTpd2Ei3g2YYuJYZlkcVVTFudRsZOPmTXfSNFOgNxwVTHRIIMfO4tT",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "to": token,
        "priority": "high",
        "notification": {
          "title": "${user.nama} membalas diskusi Anda: ${diskusi.judul}",
          "body": reply,
        }
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
}
