import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'package:dio/dio.dart';

import 'token_state.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// 카카오 로그인
Future<void> kakaoLogin(WidgetRef ref) async {
  if (await isKakaoTalkInstalled()) {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 ${token.accessToken}');
      ref.read(kakaoTokenProvider.notifier).state = token.accessToken;

      // 여기서 카카오 토큰으로 서버 트콘 발급받고 저장하기
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        print('디바이스 권한 요청 화면에서 로그인을 취소한 경우');
        return;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오톡 계정 로그인 ${token.accessToken}');
        ref.read(kakaoTokenProvider.notifier).state = token.accessToken;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return;
      }
    }
  } else {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오톡 계정 로그인 ${token.accessToken}');
      ref.read(kakaoTokenProvider.notifier).state = token.accessToken;
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
      return;
    }
  }
}

// 유저 정보
// Future getUserInfo() async {
//   try {
//     await isToken();
//     User user = await UserApi.instance.me();
//     print('사용자 정보'
//         '\n회원번호: ${user.id}'
//         '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
//         '\n프로필: ${user.kakaoAccount?.profile?.profileImageUrl}'
//         '\n이메일: ${user.kakaoAccount?.email}');

//     return user;
//   } catch (error) {
//     print('사용자 정보 요청 실패 $error');
//     await isToken();
//   }
// }

// // 카카오 토큰 유효성 체크
// Future<void> isToken() async {
//   // hasToken이 true: 기존에 발급받은 액세스 토큰 또는 리프레시 토큰이 존재
//   if (await AuthApi.instance.hasToken()) {
//     try {
//       AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
//       print('토큰 유효성 체크 성공'
//           '\n회원정보: ${tokenInfo.id}'
//           '\n만료시간: ${tokenInfo.expiresIn} 초');
//     } catch (error) {
//       if (error is KakaoException && error.isInvalidTokenError()) {
//         print('토큰 만료 $error');
//       } else {
//         print('토큰 정보 조회 실패 $error');
//       }
//       // 카카오 로그인
//       await kakaoLogin();
//     }
//   } else {
//     print('발급된 토큰 없음');
//     // 카카오 로그인
//     await kakaoLogin();
//   }
// }

// kakao 로그인 후 서버 토큰 받아내기
Future<String> fetchToken(WidgetRef ref) async {
  Dio dio = Dio();
  // 카카오 로그인 로직으로 토큰 발급
  if (ref.read(kakaoTokenProvider) == null) {
    await kakaoLogin(ref);
  }

  // 발급받은 카카오 토큰을 이용해 서버 로그인 요청
  try {
    Response response = await dio.post(
      'http://k9e102.p.ssafy.io:8000/api/user/kakao-login',
      options: Options(headers: {
        'Authorization': 'Bearer ${ref.read(kakaoTokenProvider)}',
      }),
    );

    final serverToken = response.headers.map['authorization']?.first;
    final role = response.headers.map['ROLE']?.first;
    final id = response.headers.map['id']?.first;

    // loginStateProvider를 통해 상태 갱신
    if (serverToken != null) {
      ref.read(loginStateProvider.notifier).updateServerToken(serverToken);
    }
    if (role != null) {
      ref.read(loginStateProvider.notifier).updateRole(role);
    }
    if (id != null) {
      ref.read(loginStateProvider.notifier).updateId(id);
    }

    print('서버 ${ref.read(loginStateProvider).serverToken} ================');
    print('서버롤 ${ref.read(loginStateProvider).role} ================');
    print('서버아이디 ${ref.read(loginStateProvider).id} ================');
    return serverToken!;
  } catch (e) {
    // 에러 처리
    throw Exception('서버 토큰을 가져오는데 실패했습니다: $e');
  }
}
