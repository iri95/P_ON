import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_on/common/common.dart';

import 'package:p_on/auth.dart';

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
    final auth = PonAuthScope.of(context);

    return Container(
        width: double.infinity,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                // Nav.push();
                print('1');
              },
              child: Container(
                height: 58,
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('알림 설정',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard')),
                    Expanded(
                      child: Container(),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
            height10,
            InkWell(
              onTap: () {
                auth.signOut();
                print('2');
              },
              child: Container(
                height: 58,
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('로그아웃',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard')),
                    Expanded(
                      child: Container(),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                print('3');
              },
              child: Container(
                height: 58,
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('회원 탈퇴',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard')),
                    Expanded(
                      child: Container(),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
