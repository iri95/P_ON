import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_server_url.dart';
import 'package:p_on/screen/main/tab/register/f_register.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'package:p_on/common/util/dio.dart';

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

  // Future<void> getKakao() async {
  //   try {
  //     Dio dio = Dio();
  //     String url = '$server/api/user/kakao-profile';
  //     var response = await dio.get(url);
  //     print(response);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // kakao 로그인 후 서버 토큰 받아내기
  Future<String> fetchToken() async {
    Dio dio = Dio();
    // 카카오 로그인 로직으로 토큰 발급
    final kakaoToken = await kakaoLogin();

    // 발급받은 카카오 토큰을 이용해 서버 로그인 요청
    try {
      Response response = await dio.post(
        '/api/user/kakao-login',
        options: Options(headers: {
          'Authorization': 'Bearer $kakaoToken',
        }),
      );

      final serverToken =
          response.headers.map['authorization']?.first; // 응답에서 서버 토큰 추출
      // dynamic serverId = response.headers.map['id']?.first;
      print('서버토큰 ${serverToken} ================');
      return serverToken!;
    } catch (e) {
      // 에러 처리
      throw Exception('서버 토큰을 가져오는데 실패했습니다: $e');
    }
  }

  // Future<void> getKakao() async {
  //   try {
  //     Dio dio = Dio();
  //     String url = '$server/api/user/kakao-profile';
  //     var response = await dio.get(url);
  //     print(response);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // 카카오 로그인
  Future<String> kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 ${token.accessToken}');
        return token.accessToken;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          print('디바이스 권한 요청 화면에서 로그인을 취소한 경우');
          return '';
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오톡 계정 로그인 ${token.accessToken}');
          return token.accessToken;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return '';
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오톡 계정 로그인 ${token.accessToken}');
        return token.accessToken;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return '';
      }
    }
  }

  // 유저 정보
  Future getUserInfo() async {
    try {
      await isToken();
      User user = await UserApi.instance.me();
      // print('사용자 정보'
      //     '\n회원번호: ${user.id}'
      //     '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
      //     '\n프로필: ${user.kakaoAccount?.profile?.profileImageUrl}'
      //     '\n이메일: ${user.kakaoAccount?.email}');
      return user;
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
      await isToken();
    }
  }

// 토큰 유효성 체크
  Future<void> isToken() async {
    // hasToken이 true: 기존에 발급받은 액세스 토큰 또는 리프레시 토큰이 존재
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공'
            '\n회원정보: ${tokenInfo.id}'
            '\n만료시간: ${tokenInfo.expiresIn} 초');
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
        // 카카오 로그인
        await kakaoLogin();
      }
    } else {
      print('발급된 토큰 없음');
      // 카카오 로그인
      await kakaoLogin();
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
                // 이게 키해시임
                // print(await KakaoSdk.origin);
                // 카카오로그인 -> 토큰
                await fetchToken();
                await kakaoLogin();

                await Nav.push(RegisterFragment(
                  nickName: '',
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
