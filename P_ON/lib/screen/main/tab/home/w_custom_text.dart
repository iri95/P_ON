import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final bool textColor;

  const CustomText({super.key, required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: 'Pretendard',
          color: textColor ? Colors.white : Colors.black),
    );
  }
}
