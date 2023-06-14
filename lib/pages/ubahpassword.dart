import 'package:flutter/material.dart';
import 'package:overtalk/models/userModel.dart';
import 'package:overtalk/repository.dart';
import 'package:overtalk/includes/isian.dart';
import 'package:overtalk/pages/login.dart';
import 'package:overtalk/global.dart';

class UbahPassword extends StatefulWidget {
  final UserModel user;
  const UbahPassword({super.key, required this.user});

  @override
  State<UbahPassword> createState() => _UbahPasswordState();
}

class _UbahPasswordState extends State<UbahPassword> {
  final Repository repository = Repository();
  TextEditingController lamaController = TextEditingController();
  TextEditingController baruController = TextEditingController();
  TextEditingController kBaruController = TextEditingController();
  String error = "";
  bool loading = false;

  void simpan() async {
    loading = true;
    setState(() {});

    //--- Error Checking ---//
    error = "";
    if (baruController.text != kBaruController.text) {
      error = "Kedua password tidak sama";
    }
    if (baruController.text.length < 8) {
      error = "Password minimal 8 karakter";
    }
    if (lamaController.text != widget.user.password) {
      error = "Password lama salah";
      print(lamaController.text);
      print(widget.user.password);
    }
    setState(() {});

    if (error == "") {
      final response = await repository.updateUser(
        widget.user.id,
        widget.user.nama,
        widget.user.email,
        baruController.text,
      );

      if (response) {
        if (context.mounted) {
          List<UserModel> listUser = await repository.getUsers();
          error = "Gagal Login Kembali";
          for (var element in listUser) {
            if (element.email == widget.user.email) {
              error = "";
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
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
          icon: Icon(
            Icons.close,
            color: GlobalColors.onBackground,
          ),
          iconSize: 25,
        ),
        leadingWidth: 40,
        title: Text(
          "Ubah Password",
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
                style: TextStyle(
                  color: Colors.red,
                ),
              ),

              //--- Password Lama ---//
              Isian(
                labelText: "Password lama",
                controller: lamaController,
                obscure: true,
              ),

              //--- Password Baru ---//
              Isian(
                labelText: "Password Baru",
                controller: baruController,
                obscure: true,
              ),

              //--- Konfirmasi Password Baru ---//
              Isian(
                labelText: "Konfirmasi Password Baru",
                controller: kBaruController,
                obscure: true,
              ),

              //--- Tombol Simpan ---//
              InkWell(
                onTap: simpan,
                child: Container(
                  height: 36,
                  margin: EdgeInsets.fromLTRB(90, 40, 90, 0),
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
                        color: Colors.white,
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
