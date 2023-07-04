import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overtalk/auth/forgotpassword.dart';
import 'package:overtalk/models/user_model.dart';
import 'package:overtalk/repository.dart';
import 'package:overtalk/auth/daftar.dart';
import 'package:overtalk/includes/inputteks.dart';
import 'package:overtalk/global.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Repository repository = Repository();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String error = "";
  bool loading = false;

  void login() async {
    setState(() {
      loading = true;
      error = "";
    });

    //--- Error Checking ---//
    if (passwordController.text.isEmpty) {
      error = "Password tidak boleh kosong";
    }
    if (emailController.text.isEmpty) {
      error = "Email tidak boleh kosong";
    }
    setState(() {});

    if (error == "") {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        UserModel user = await repository.getUser(emailController.text.trim());
        user.token = await FirebaseMessaging.instance.getToken();
        await repository.updateUser(user);
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "ERROR_INVALID_EMAIL":
          case "invalid-email":
            error = "Email tidak valid";
            break;
          case "ERROR_USER_NOT_FOUND":
          case "user-not-found":
            error = "Email tidak terdaftar";
            break;
          case "ERROR_WRONG_PASSWORD":
          case "wrong-password":
            error = "Password Anda salah";
            break;
          case "ERROR_EMAIL_ALREADY_IN_USE":
          case "email-already-in-use":
            error = "Email Anda sedang dipakai";
            break;
          default:
            error = "Gagal login, silahkan coba lagi";
            break;
        }
      }
    }

    loading = false;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
              padding: const EdgeInsets.only(top: 27, bottom: 10),
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(top: 27),
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
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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

                  //--- Tombol Login ---//
                  InkWell(
                    onTap: login,
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
                          "Login",
                          style: TextStyle(
                            color: GlobalColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //--- Jarak ---//
                  const SizedBox(height: 10),

                  //--- Forgot Password ---//
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPassword(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
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

            //--- Daftar akun baru ---//
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Daftar(),
                    ),
                  );
                },
                child: const Text(
                  "Create an account",
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
