import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overtalk/auth/mainpage.dart';
import 'package:overtalk/models/user_model.dart';
import 'package:overtalk/repository.dart';
import 'package:overtalk/includes/isian.dart';
import 'package:overtalk/global.dart';

class Setelan extends StatefulWidget {
  final UserModel? user;

  const Setelan({
    super.key,
    this.user,
  });

  @override
  State<Setelan> createState() => _SetelanState();
}

class _SetelanState extends State<Setelan> {
  final _email = FirebaseAuth.instance.currentUser!.email!;
  final Repository repository = Repository();
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool loading = false;
  String error = "";
  int kHapusAkun = 0;
  bool _kGantiFoto = false;

  void simpan() async {
    loading = true;
    setState(() {});

    //--- Error Checking ---//
    error = "";
    if (namaController.text == "") {
      error = "Nama tidak boleh kosong";
    }
    setState(() {});

    if (error == "") {
      UserModel user = await repository.getUser(_email);
      final response = await repository.updateUser(user);

      if (response) {
        if (context.mounted) Navigator.pop(context);
      }
    }

    loading = false;
    setState(() {});
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPage(),
      ),
      (e) => false,
    );
  }

  void hapusAkun() async {
    if (kHapusAkun == 1) {
      repository.hapusAkun(_email);
      await FirebaseAuth.instance.currentUser?.delete();
      logout();
    }
    kHapusAkun++;
    setState(() {});
  }

  void gantiFoto() async {
    if (_kGantiFoto) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      setState(() {
        _kGantiFoto = false;
      });
      if (result == null) return;

      final foto = result.files.first;
      uploadFoto(foto);
    } else {
      setState(() {
        _kGantiFoto = true;
      });
    }
  }

  void uploadFoto(PlatformFile foto) async {
    final ref =
        FirebaseStorage.instance.ref().child("profile_pictures/$_email");
    final uploadTask = ref.putFile(File(foto.path!));

    final snapshot = await uploadTask.whenComplete(() {});
    final fotoUrl = await snapshot.ref.getDownloadURL();

    UserModel user = await repository.getUser(_email);
    user.fotoUrl = fotoUrl;
    await repository.updateUser(user);
  }

  void reload() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Setelan(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
  }

  @override
  void initState() {
    super.initState();
    namaController.text = widget.user?.nama ?? "";
    emailController.text = _email;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Settings",
          style: TextStyle(color: GlobalColors.onBackground),
        ),
      ),

      //--- Body ---//
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              //--- Foto Profil ---//
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Stack(
                        children: [
                          Image(
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.user?.fotoUrl ?? ""),
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/profile.jpg",
                              );
                            },
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: gantiFoto,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: _kGantiFoto ? 1 : 0,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.black26,
                                  child: const Icon(
                                    Icons.file_upload_outlined,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //--- Penulisan Eror ---//
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),

              //--- Account ---//
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Account",
                  style: TextStyle(
                    color: GlobalColors.prettyGrey,
                  ),
                ),
              ),
              Isian(
                labelText: "Nama",
                controller: namaController,
              ),
              Isian(
                labelText: "Email",
                controller: emailController,
                keyboardype: TextInputType.emailAddress,
                readOnly: true,
              ),
              // ListTile(
              //   onTap: () {},
              //   title: const Text(
              //     "Ubah Password",
              //     style: TextStyle(
              //       color: GlobalColors.onBackground,
              //     ),
              //   ),
              // ),

              //--- Settings ---//
              const Padding(
                padding: EdgeInsets.only(bottom: 10, top: 40),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: GlobalColors.prettyGrey,
                  ),
                ),
              ),
              ListTile(
                onTap: logout,
                title: const Text(
                  "Keluar Akun",
                  style: TextStyle(
                    color: GlobalColors.onBackground,
                  ),
                ),
              ),
              const Divider(
                color: GlobalColors.prettyGrey,
                thickness: 1,
                height: 1,
              ),
              ListTile(
                onTap: hapusAkun,
                title: Text(
                  kHapusAkun == 0 ? "Hapus Akun" : "Konfirmasi hapus akun?",
                  style: const TextStyle(
                    color: GlobalColors.onBackground,
                  ),
                ),
              ),
              const Divider(
                color: GlobalColors.prettyGrey,
                thickness: 1,
                height: 1,
              ),

              //--- Tombol Simpan ---//
              InkWell(
                onTap: simpan,
                child: Container(
                  height: 36,
                  margin: const EdgeInsets.fromLTRB(90, 27, 90, 0),
                  decoration: BoxDecoration(
                    color: loading
                        ? GlobalColors.primaryColor.withOpacity(0.5)
                        : GlobalColors.primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      "Simpan",
                      style: TextStyle(
                        color: GlobalColors.onPrimaryColor,
                        fontWeight: FontWeight.bold,
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
