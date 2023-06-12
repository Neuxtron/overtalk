import 'package:flutter/material.dart';
import 'package:overtalk/api/modelUser.dart';
import 'package:overtalk/api/repository.dart';
import 'package:overtalk/homepage.dart';
import 'package:overtalk/includes/isian.dart';
import 'package:overtalk/login.dart';
import 'package:overtalk/themes/global.dart';
import 'package:overtalk/ubahpassword.dart';

class Setelan extends StatefulWidget {
  final User user;
  const Setelan({super.key, required this.user});

  @override
  State<Setelan> createState() => _SetelanState();
}

class _SetelanState extends State<Setelan> {
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
    List<User> listUser = await repository.getUsers();
    error = "";
    for (var element in listUser) {
      if (element.email == emailController.text &&
          emailController.text != widget.user.email) {
        error = "Email sudah terdaftar";
      }
    }
    if (emailController.text == "") {
      error = "Email tidak boleh kosong";
    }
    if (namaController.text == "") {
      error = "Nama tidak boleh kosong";
    }
    setState(() {});

    if (error == "") {
      final response = await repository.updateUser(
        widget.user.id,
        namaController.text,
        emailController.text,
        widget.user.password,
      );

      if (response) {
        if (context.mounted) {
          List<User> listUser = await repository.getUsers();
          error = "Gagal Login Kembali";
          for (var element in listUser) {
            if (element.email == emailController.text) {
              error = "";
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    user: element,
                  ),
                ),
                (e) => false,
              );
            }
          }
        }
      }
    }

    loading = false;
    setState(() {});
  }

  void ubahPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UbahPassword(
          user: widget.user,
        ),
      ),
    );
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
      (e) => false,
    );
  }

  void hapusAkun() {
    if (kHapusAkun == 1) {
      repository.hapusAkun(widget.user.id);
      logout();
    }
    kHapusAkun++;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    emailController.dispose();
  }

  @override
  void initState() {
    super.initState();
    namaController.text = widget.user.nama;
    emailController.text = widget.user.email;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors().backgroundColor,

      //--- AppBar ---//
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: GlobalColors().onBackground,
          ),
          iconSize: 25,
        ),
        leadingWidth: 40,
        title: Text(
          "Settings",
          style: TextStyle(color: GlobalColors().onBackground),
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
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      image: NetworkImage(""),
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
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),

              //--- Account ---//
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
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
                onTap: ubahPassword,
                title: Text(
                  "Ubah Password",
                  style: TextStyle(
                    color: GlobalColors().onBackground,
                  ),
                ),
              ),

              //--- Settings ---//
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 40),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: GlobalColors.prettyGrey,
                  ),
                ),
              ),
              ListTile(
                onTap: logout,
                title: Text(
                  "Keluar Akun",
                  style: TextStyle(
                    color: GlobalColors().onBackground,
                  ),
                ),
              ),
              Divider(
                color: GlobalColors.prettyGrey,
                thickness: 1,
                height: 1,
              ),
              ListTile(
                onTap: hapusAkun,
                title: Text(
                  kHapusAkun == 0 ? "Hapus Akun" : "Konfirmasi hapus akun?",
                  style: TextStyle(
                    color: GlobalColors().onBackground,
                  ),
                ),
              ),
              Divider(
                color: GlobalColors.prettyGrey,
                thickness: 1,
                height: 1,
              ),

              //--- Tombol Simpan ---//
              InkWell(
                onTap: simpan,
                child: Container(
                  height: 36,
                  margin: EdgeInsets.fromLTRB(90, 27, 90, 0),
                  decoration: BoxDecoration(
                    color: loading
                        ? GlobalColors.primaryColor.withOpacity(0.5)
                        : GlobalColors.primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
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
