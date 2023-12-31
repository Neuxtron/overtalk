import 'package:flutter/material.dart';
import 'package:overtalk/global.dart';

class Isian extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardype;
  final bool obscure;
  final bool readOnly;

  const Isian({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardype = TextInputType.text,
    this.obscure = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: TextField(
        controller: controller,
        keyboardType: keyboardype,
        obscureText: obscure,
        readOnly: readOnly,
        style: const TextStyle(color: GlobalColors.onBackground),
        cursorColor: GlobalColors.onBackground,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: GlobalColors.prettyGrey),
          contentPadding: const EdgeInsets.only(top: 3),
          floatingLabelStyle: const TextStyle(color: GlobalColors.onBackground),
          enabledBorder: readOnly
              ? InputBorder.none
              : const UnderlineInputBorder(
                  borderSide: BorderSide(color: GlobalColors.prettyGrey),
                ),
          focusedBorder: readOnly
              ? InputBorder.none
              : const UnderlineInputBorder(
                  borderSide: BorderSide(color: GlobalColors.onBackground),
                ),
        ),
      ),
    );
  }
}
