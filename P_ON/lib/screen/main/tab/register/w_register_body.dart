import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/util/app_keyboard_util.dart';
import 'package:p_on/screen/main/tab/register/w_profileImage.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> with AfterLayoutMixin {
  final textController = TextEditingController();
  final node = FocusNode();


  @override
  void initState() {
    super.initState();
    textController.addListener(updateTextLength);
  }

  void updateTextLength() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.all(24),
            alignment: Alignment.topLeft,
            child: '친구들에게 보여질 프로필을 설정하세요'.text.black.size(16).semiBold.make()),
        Container(
            height: 80,
            alignment: Alignment.center,
            child: const ProfileImage()),
        Container(
          margin: EdgeInsets.all(24),
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.mainBlue2)),
          child: TextField(
            focusNode: node,
            controller: textController,
            maxLength: 10,
            decoration: InputDecoration(
                hintText: '카카오에서 받아온 닉넴',
                suffix: Text('${textController.text.length}/10'),
                counterText: '',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ),
        )
      ],
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    AppKeyboardUtil.show(context, node);
  }
}
