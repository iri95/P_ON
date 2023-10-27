import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

class BasicAppBar extends StatelessWidget {
  final String text;
  const BasicAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border:
          Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Nav.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          text,
          style: const TextStyle(
            color: Colors.black
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
