import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overtalk/models/user_model.dart';
import 'package:overtalk/repository.dart';
import 'package:overtalk/includes/isian.dart';
import 'package:overtalk/global.dart';

class BukaDiskusi extends StatefulWidget {
  const BukaDiskusi({
    super.key,
  });

  @override
  State<BukaDiskusi> createState() => _BukaDiskusiState();
}

class _BukaDiskusiState extends State<BukaDiskusi> {
  final _email = FirebaseAuth.instance.currentUser!.email!;
  final Repository repository = Repository();

  TextEditingController judulController = TextEditingController();
  TextEditingController kontenController = TextEditingController();
  String error = "";

  Future<UserModel> getCurrentUser() async {
    UserModel user = await repository.getUser(_email);
    return user;
  }

  void bukaDiskusi() async {
    error = "";
    if (kontenController.text == "") {
      error = "Konten tidak bisa kosong";
    }
    if (judulController.text == "") {
      error = "Judul tidak bisa kosong";
    }
    setState(() {});

    UserModel user = await getCurrentUser();

    if (error == "") {
      final response = await repository.bukaDiskusi(
        judulController.text.trim(),
        kontenController.text.trim(),
        user.id,
      );

      if (response) {
        if (context.mounted) Navigator.pop(context);
      } else {
        error = "Gagal membuka diskusi";
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    judulController.dispose();
    kontenController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor,

      //--- AppBar ---//
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: GlobalColors.onBackground,
          ),
          iconSize: 25,
        ),
        leadingWidth: 40,
        title: const Text(
          "Buka Diskusi",
          style: TextStyle(color: GlobalColors.onBackground),
        ),
      ),

      //--- Body ---//
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //
              //--- Penulisan Eror ---//
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),

              //--- Input Judul ---//
              Isian(
                labelText: "Judul Diskusi",
                controller: judulController,
              ),

              //--- Input Konten ---//
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: kontenController,
                  maxLines: 20,
                  style: const TextStyle(color: GlobalColors.onBackground),
                  cursorColor: GlobalColors.onBackground,
                  decoration: InputDecoration(
                    labelText: "Konten",
                    labelStyle: const TextStyle(color: GlobalColors.prettyGrey),
                    alignLabelWithHint: true,
                    floatingLabelStyle:
                        const TextStyle(color: GlobalColors.onBackground),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: GlobalColors.prettyGrey,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: GlobalColors.prettyGrey,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),

              //--- Tombol Kirim ---//
              InkWell(
                onTap: bukaDiskusi,
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.fromLTRB(70, 40, 70, 0),
                  decoration: BoxDecoration(
                    color: GlobalColors.primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      "Buka Diskusi",
                      style: TextStyle(
                        color: GlobalColors.onPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
