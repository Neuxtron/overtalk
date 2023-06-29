import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overtalk/models/user_model.dart';
import 'package:overtalk/repository.dart';
import 'package:overtalk/includes/isian.dart';
import 'package:overtalk/auth/login.dart';
import 'package:overtalk/global.dart';

class Setelan extends StatefulWidget {
  final String namaUser;
  const Setelan({
    super.key,
    required this.namaUser,
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
      final response = await repository.updateUser(
        user.id,
        namaController.text,
        _email,
        user.bookmarks,
      );

      if (response) {
        if (context.mounted) Navigator.pop(context);
      }
    }

    loading = false;
    setState(() {});
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
      (e) => false,
    );
  }

  void hapusAkun() {
    if (kHapusAkun == 1) {
      repository.hapusAkun(_email);
      logout();
    }
    kHapusAkun++;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
  }

  @override
  void initState() {
    super.initState();
    namaController.text = widget.namaUser;
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
              //--- Foto Profil ---//
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      image: const NetworkImage(""),
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/profile.jpg",
                          width: 100,
                        );
                      },
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
              ),
              ListTile(
                onTap: () {},
                title: const Text(
                  "Ubah Password",
                  style: TextStyle(
                    color: GlobalColors.onBackground,
                  ),
                ),
              ),

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
