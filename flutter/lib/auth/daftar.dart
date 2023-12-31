import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overtalk/repository.dart';
import 'package:overtalk/includes/inputteks.dart';
import 'package:overtalk/global.dart';

class Daftar extends StatefulWidget {
  const Daftar({super.key});

  @override
  State<Daftar> createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  final Repository repository = Repository();

  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController kPasswordController = TextEditingController();

  String error = "";
  bool loading = false;

  void signUp() async {
    setState(() {
      loading = true;
    });

    //--- Error Checking ---//
    error = "";
    if (passwordController.text != kPasswordController.text) {
      error = "Kedua password tidak sama";
    }
    if (passwordController.text.length < 8) {
      error = "Password minimal 8 karakter";
    }
    if (emailController.text == "") {
      error = "Email tidak boleh kosong";
    }
    if (namaController.text == "") {
      error = "Nama tidak boleh kosong";
    }
    setState(() {});

    if (error == "") {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        if (mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        setState(() {
          error = e.message.toString();
        });
      }
    }

    if (error == "") {
      final response = await repository.daftar(
        namaController.text,
        emailController.text,
        passwordController.text,
      );
      if (response) {
        if (context.mounted) Navigator.pop(context);
      } else {
        error = "Gagal mendaftar akun";
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  bool confirmPassword() {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    kPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            //
            //--- Logo OverTalk ---//
            Padding(
              padding: const EdgeInsets.only(top: 80, bottom: 30),
              child: Image.asset(
                "assets/splash_light.png",
                height: 90,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 27),
              decoration: BoxDecoration(
                color: GlobalColors.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  //
                  //
                  //--- Judul Halaman ---//
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //--- Penulisan Eror ---//
                  Padding(
                    padding: const EdgeInsets.only(top: 27),
                    child: Text(
                      error,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),

                  //--- Input Nama ---//
                  InputTeks(
                    hint: "Nama",
                    keyboardType: TextInputType.name,
                    controller: namaController,
                  ),

                  //--- Input Email ---//
                  InputTeks(
                    hint: "Email",
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),

                  //--- Input Password ---//
                  InputTeks(
                    hint: "Password",
                    obscure: true,
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                  ),

                  //--- Input Konfirmasi Password ---//
                  InputTeks(
                    hint: "Konfirmasi Password",
                    obscure: true,
                    keyboardType: TextInputType.text,
                    controller: kPasswordController,
                  ),

                  //--- Tombol Daftar ---//
                  InkWell(
                    onTap: () {
                      if (!loading) signUp();
                    },
                    child: Container(
                      height: 36,
                      margin: const EdgeInsets.fromLTRB(90, 27, 90, 0),
                      decoration: BoxDecoration(
                        color: loading
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign Up",
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

            //--- Jarak ---//
            const SizedBox(
              height: 20,
            ),

            //--- Sudah punya akun ---//
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Sign in to existing account",
                  style: TextStyle(
                    color: GlobalColors.prettyGrey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
