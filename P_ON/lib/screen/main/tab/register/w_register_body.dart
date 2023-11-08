import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/util/app_keyboard_util.dart';
import 'package:p_on/screen/main/tab/register/w_profileImage.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterBody extends StatefulWidget {
  String nickName;
  String profileImage;
  Function(String) onNickNameChanged;

  RegisterBody(
      {super.key,
      required this.nickName,
      required this.profileImage,
      required this.onNickNameChanged});
  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> with AfterLayoutMixin {
  final nicknameController = TextEditingController();
  final node = FocusNode();

  @override
  void initState() {
    super.initState();
    nicknameController.text = widget.nickName;
    nicknameController.addListener(updateTextLength);
  }

  void updateTextLength() {
    setState(() {});
  }

  void dispose() {
    nicknameController.dispose();
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
        // 프로필 사진
        Container(
            height: 80,
            alignment: Alignment.center,
            child: ProfileImage(profileImage: widget.profileImage)),
        // 닉네임
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
            controller: nicknameController,
            maxLength: 10,
            decoration: InputDecoration(
                suffix: Text('${nicknameController.text.length}/10'),
                counterText: '',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
            onChanged: widget.onNickNameChanged,
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
