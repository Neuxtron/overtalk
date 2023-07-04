import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overtalk/global.dart';
import 'package:overtalk/includes/inputteks.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  bool _loading = false;
  String _error = "";

  void popUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void passwordReset() async {
    setState(() {
      _loading = true;
      _error = "";
    });

    //--- Error Checking ---//
    if (_emailController.text.isEmpty) {
      _error = "Email tidak boleh kosong";
    }
    setState(() {});

    if (_error == "") {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        popUp("Link dikirim!\nSilahkan periksa email Anda");
      } on FirebaseAuthException catch (e) {
        popUp(e.message.toString());
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            //--- Logo OverTalk ---//
            Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 30),
              child: Image.asset(
                "assets/splash_light.png",
                height: 90,
              ),
            ),

            //--- Penulisan Eror ---//
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                _error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                color: GlobalColors.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  //--- Tombol Kembali ---//
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  //--- Judul Halaman ---//
                  const Center(
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  //--- Teks ---//
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 40, left: 20, right: 20, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Silahkan masukkan email Anda",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  //--- Input Email ---//
                  InputTeks(
                    hint: "Email",
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),

                  //--- Tombol Login ---//
                  InkWell(
                    onTap: passwordReset,
                    child: Container(
                      height: 36,
                      margin: const EdgeInsets.fromLTRB(90, 27, 90, 0),
                      decoration: BoxDecoration(
                        color: _loading
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                            color: GlobalColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
