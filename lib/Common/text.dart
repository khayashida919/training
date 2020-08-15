
import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  BoldText(this.text, this.fontSize);

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: fontSize),
    );
  }
}
