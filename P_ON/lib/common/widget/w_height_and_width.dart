import 'package:flutter/material.dart';

const width5 = Width(5);
const width10 = Width(10);
const width20 = Width(20);
const width30 = Width(30);
const width40 = Width(40);
const width50 = Width(50);
const width60 = Width(60);
const width70 = Width(70);
const width80 = Width(80);
const width90 = Width(90);
const width100 = Width(100);

const height5 = Height(5);
const height10 = Height(10);
const height20 = Height(20);
const height30 = Height(30);
const height40 = Height(40);
const height50 = Height(50);
const height60 = Height(60);
const height70 = Height(70);
const height80 = Height(80);
const height90 = Height(90);
const height100 = Height(100);

class Height extends StatelessWidget {
  final double height;

  const Height(
    this.height, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class Width extends StatelessWidget {
  final double width;

  const Width(
    this.width, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
