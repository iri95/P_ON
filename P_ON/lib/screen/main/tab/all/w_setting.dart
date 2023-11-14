import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_on/common/common.dart';

class Setting extends StatefulWidget {
  const Setting({
    Key? key,
  }) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("ㅅㅌ")).pSymmetric(h: 16, v: 10);
  }
}
