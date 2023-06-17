import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overtalk/global.dart';
import 'package:overtalk/models/userModel.dart';
import 'package:overtalk/pages/homepage.dart';
import 'package:overtalk/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel user =
        UserModel("1", "zuzuzu@gmail.com", "Zuzuzu", "Hmmm", [1, 1, 1]);

    return MaterialApp(
      home: HomePage(user: user),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: GlobalColors.primaryColor,
        ),
      ),
    );
  }
}
