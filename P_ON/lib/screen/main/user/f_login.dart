import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_server_url.dart';
import 'package:p_on/screen/main/tab/register/f_register.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with AfterLayoutMixin {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    FlutterNativeSplash.remove();
  }

  Future<void> getKakao() async {
    try {
      Dio dio = Dio();
      String url = '$server/api/user/kakao-profile';
      var response = await dio.get(url);
      print(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Image.asset('assets/image/main/login.png'),
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.fromLTRB(50, 20, 50, 80),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF9E000)),
            child: TextButton(
              onPressed: () async {
                await getKakao();
                Nav.push(RegisterFragment(
                  nickName: "닉네임",
                  profileImage: "이미지 주소",
                  privacy: "PRIVATE",
                ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/image/icon/kakao.png',
                      width: 48, height: 48),
                  const Text('카카오로 시작하기',
                      style: TextStyle(
                          color: Color(0xff371C1D),
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w700))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
