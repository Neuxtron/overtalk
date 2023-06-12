import 'package:flutter/material.dart';

class InputTeks extends StatelessWidget {
  final String hint;
  final bool obscure;
  final double tMargin;
  final double bMargin;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const InputTeks({
    super.key,
    required this.hint,
    this.obscure = false,
    this.tMargin = 6,
    this.bMargin = 0,
    required this.keyboardType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      margin: EdgeInsets.fromLTRB(20, tMargin, 20, bMargin),
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            isCollapsed: true,
            hintText: hint,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
