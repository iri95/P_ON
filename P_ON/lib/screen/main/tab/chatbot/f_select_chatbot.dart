import 'package:flutter/material.dart';

class SelectChatBot extends StatefulWidget {
  final String id;
  const SelectChatBot({super.key, required this.id});

  @override
  State<SelectChatBot> createState() => _SelectChatBotState();
}

class _SelectChatBotState extends State<SelectChatBot> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.white,

        ),
      ),
    );
  }
}
