import 'package:flutter/material.dart';
import 'package:overtalk/themes/global.dart';

class DrawerItem extends StatelessWidget {
  final String text;
  final EdgeInsets margin;
  final bool selected;
  final Function onTap;

  const DrawerItem({
    super.key,
    required this.text,
    this.margin = const EdgeInsets.only(top: 10),
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: margin,
        width: selected ? 280 : 255,
        decoration: BoxDecoration(
          color: GlobalColors().backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: selected ? 16 : 12,
            horizontal: selected ? 20 : 15,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: GlobalColors().onBackground,
              fontSize: selected ? 20 : 15,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
