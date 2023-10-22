import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p_on/home.dart';
import 'package:p_on/historyScreen.dart';
import 'package:p_on/planScreen.dart';
import 'package:p_on/myPageScreen.dart';

void main() {
  runApp(const ponApp());
}

class ponApp extends StatefulWidget {
  const ponApp({super.key});

  @override
  State<ponApp> createState() => _ponAppState();
}

class _ponAppState extends State<ponApp> {
  late int selectedPage;
  @override
  void initState() {
    super.initState();
    selectedPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
          secondary: Colors.black,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.black
        ),
        useMaterial3: true,
      ),
      home: const homeScreen(),
    );
  }
}
