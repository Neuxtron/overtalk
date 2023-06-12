import 'package:flutter/material.dart';
import 'package:overtalk/api/modelUser.dart';
import 'package:overtalk/api/repository.dart';
import 'package:overtalk/daftar.dart';
import 'package:overtalk/homepage.dart';
import 'package:overtalk/includes/inputteks.dart';
import 'package:overtalk/themes/global.dart';

class Login extends StatefulWidget {
  Login({super.key});

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
    loading = true;
    setState(() {});

    List<User> listUser = await repository.getUsers();
    error = "Gagal Login";
    for (var element in listUser) {
      if (element.email == emailController.text &&
          element.password == passwordController.text) {
        error = "";
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              user: element,
            ),
          ),
        );
      }
    }
    loading = false;
    setState(() {});
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
      backgroundColor: GlobalColors().backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            //
            //--- Logo OverTalk ---//
            Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 30),
              child: Image.asset(
                "assets/splash_light.png",
                height: 90,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 27),
              decoration: BoxDecoration(
                color: GlobalColors.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  //
                  //
                  //--- Judul Halaman ---//
                  Text(
                    "Login",
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
                      style: TextStyle(
                        color: Colors.red,
                      ),
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
                      margin: EdgeInsets.fromLTRB(90, 27, 90, 0),
                      decoration: BoxDecoration(
                        color: loading
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
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
                ],
              ),
            ),

            //--- Jarak ---//
            SizedBox(
              height: 20,
            ),

            //--- Daftar akun baru ---//
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Daftar(),
                    ),
                  );
                },
                child: Text(
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
