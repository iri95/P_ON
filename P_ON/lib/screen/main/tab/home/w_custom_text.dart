import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;

  const CustomText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: 'Pretendard',
          color: Colors.black),
    );
  }
}
