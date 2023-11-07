import 'package:p_on/common/common.dart';
import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:velocity_x/velocity_x.dart';

import 'w_register_body.dart';

class RegisterFragment extends StatefulWidget {
  String nickName;
  String profileImage;
  String privacy;

  RegisterFragment({
    super.key,
    required this.nickName,
    required this.profileImage,
    required this.privacy,
  });

  @override
  State<RegisterFragment> createState() => _RegisterFragmentState();
}

class _RegisterFragmentState extends State<RegisterFragment> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
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
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
              title: '회원가입'.text.black.make(),
              centerTitle: true,
            ),
          ),
        ),
        body: RegisterBody(nickName: widget.nickName, profileImage: widget.profileImage),
        bottomSheet: Container(
          width: double.infinity,
          height: 48,
          margin: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          decoration: BoxDecoration(
              color: AppColors.mainBlue,
              borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () {},
            child: '확인'.text.semiBold.white.make(),
          ),
        ),
      ),
    );
  }
}
