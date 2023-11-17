import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight? fontWeightValue;

  const CustomText(
      {super.key,
      required this.text,
      required this.color,
      this.fontWeightValue});

  FontWeight convertFontWeight() {
    return fontWeightValue ??
        FontWeight.normal; // fontWeightValue가 null이면 FontWeight.normal 반환
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 20,
          fontWeight: convertFontWeight(),
          fontFamily: 'Pretendard',
          color: color),
    );
  }
}
