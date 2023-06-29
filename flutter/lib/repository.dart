import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:overtalk/models/diskusi_model.dart';
import 'package:overtalk/models/replies_model.dart';
import 'package:overtalk/models/user_model.dart';

class Repository {
  final _baseUrl = "http://192.168.18.14:3000";

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
  Future bukaDiskusi(String judul, String konten, int idUser) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/diskusi"),
        headers: <String, String>{"content-type": "application/json"},
        body: jsonEncode({
          "judul": judul,
          "konten": konten,
          "idUser": idUser,
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
  Future reply(int idDiskusi, int idUser, String reply) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/replies"),
        headers: <String, String>{"content-type": "application/json"},
        body: jsonEncode({
          "idDiskusi": idDiskusi,
          "idUser": idUser,
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

  //--- Update User ---//
  Future updateUser(
      int idUser, String nama, String email, List bookmarks) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/users"),
        headers: <String, String>{"content-type": "application/json"},
        body: jsonEncode({
          "id": idUser,
          "nama": nama,
          "email": email,
          "bookmarks": bookmarks,
        }),
      );

      print(response.body);

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
}
