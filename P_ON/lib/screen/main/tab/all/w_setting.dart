import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_on/common/common.dart';

import 'package:p_on/auth.dart';
import 'package:p_on/screen/main/s_main.dart';
import 'package:p_on/screen/main/tab/tab_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Setting extends ConsumerStatefulWidget {
  const Setting({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Setting> createState() => _SettingState();
}

class _SettingState extends ConsumerState<Setting> {
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
              onTap: () async {
                await auth.signOut(context, ref);
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
                // TODO: 탈퇴 모달 띄우기
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        content: Container(
                            width: 280,
                            height: 260,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('정말 탈퇴하시겠어요?',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const Center(
                                        child: Text(
                                            '탈퇴 버튼 선택 시, 계정은 \n삭제되며 복구되지 않습니다',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500))),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Container(
                                        width: 240,
                                        height: 44,
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xff3f48cc),
                                              disabledForegroundColor:
                                                  Color(0xffa3b4ed),
                                            ),
                                            onPressed: () async {
                                              await auth.deleteUser(ref);
                                            },
                                            child: const Text(
                                              '탈퇴',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Pretendard',
                                                  color: Colors.white),
                                            ))),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                        width: 240,
                                        height: 44,
                                        child: TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xffe4e8ef)),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (states) {
                                                  if (states.contains(
                                                      MaterialState.pressed)) {
                                                    return Colors.grey;
                                                  }
                                                  return Colors.black;
                                                },
                                              ),
                                            ),
                                            onPressed: () {
                                              Nav.pop(context);
                                            },
                                            child: const Text(
                                              '취소',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Pretendard',
                                                  color: Color(0xff333B4F)),
                                            ))),
                                  ]),
                            )));
                  },
                );
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
