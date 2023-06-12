import 'package:flutter/material.dart';
import 'package:overtalk/themes/global.dart';
import 'package:overtalk/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: GlobalColors.primaryColor,
        ),
      ),
    );
  }
}
