import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:overtalk/models/diskusiModel.dart';
import 'package:overtalk/models/userModel.dart';

class Repository {
  final _baseUrl = "https://64620ee8491f9402f4b1662e.mockapi.io/";

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
          "password": password,
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

  //--- Ambil Data Users ---//
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
  Future bukaDiskusi(
      String judul, String konten, String pembuka, String createdAt) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/diskusi"),
        headers: <String, String>{"content-type": "application/json"},
        body: jsonEncode({
          "judul": judul,
          "konten": konten,
          "pembuka": pembuka,
          "createdAt": createdAt
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

  //--- Tambah Reply ---//
  Future updateReplies(String idDiskusi, List replies) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/diskusi/$idDiskusi"),
        headers: <String, String>{"content-type": "application/json"},
        body: jsonEncode({
          "replies": replies,
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
      String id, String nama, String email, String password) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/users/$id"),
        headers: <String, String>{"content-type": "application/json"},
        body: jsonEncode({
          "nama": nama,
          "email": email,
          "password": password,
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

  //--- Hapus Akun ---//
  Future hapusAkun(String id) async {
    try {
      final response = await http.delete(Uri.parse("$_baseUrl/users/$id"));

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
  Future updateBookmarks(String idUser, List bookmarks) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/users/$idUser"),
        headers: <String, String>{"content-type": "application/json"},
        body: jsonEncode({
          "bookmarks": bookmarks,
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
