import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'package:dio/dio.dart';
import 'token_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io'; //Platform 사용을 위한 패키지
import 'package:flutter/services.dart'; //PlatformException 사용을 위한 패키지
import 'package:device_info/device_info.dart'; // 디바이스 정보 사용 패키지
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:p_on/screen/main/user/user_state.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:flutter/foundation.dart';

// 디바이스 아이디 받아오기
Future<String> getMobileId() async {
  // DeviceInfoPlugin 클래스 생성
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // id 저장할 변수
  String id = '';
  try {
    // 플랫폼 확인
    if (Platform.isAndroid) {
      // 안드로이드의 경우 androidInfo를 이용
      // 이때 await으로 데이터 받을때까지 대기를 해야함
      final AndroidDeviceInfo androidData = await deviceInfoPlugin.androidInfo;
      // 전달 받은 변수의 멤버 변수인 androidId가 고유 id이다.
      id = androidData.androidId;
    } else if (Platform.isIOS) {
      // iOS의 경우 iosInfo를 이용
      // 이때 await으로 데이터 받을때까지 대기를 해야함
      final IosDeviceInfo iosData = await deviceInfoPlugin.iosInfo;
      // 전달 받은 변수의 멤버 변수인 identifierForVendor가 고유 id이다.
      id = iosData.identifierForVendor;
    }
  } on PlatformException {
    // 어떠한 원인으로 실패할 경우
    id = '';
  }
  // id 한번 출력해보고
  print('id: $id');
  // 값 리턴
  return id;
}

// FCM 토큰 받아오기
Future getFCMToken() async {
  String? token;
  if (Platform.isAndroid) {
    token = await FirebaseMessaging.instance.getToken();
  }
  return token;
}

// 카카오 로그인
Future<void> kakaoLogin(WidgetRef ref) async {
  if (!kIsWeb) {
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
          // print('카카오톡 계정 로그인 ${token.accessToken}');
          ref.read(kakaoTokenProvider.notifier).state = token.accessToken;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return;
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        // print('카카오톡 계정 로그인 ${token.accessToken}');
        ref.read(kakaoTokenProvider.notifier).state = token.accessToken;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return;
      }
    }
  } else if (kIsWeb) {
    var redirectUri = "https://p-on.site:8000/login/oauth2/code/kakao";
    if (await isKakaoTalkInstalled()) {
      try {
        await AuthCodeClient.instance.authorizeWithTalk(
          redirectUri: '${redirectUri}',
        );
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
      }
    } else {
      try {
        await AuthCodeClient.instance.authorize(
          redirectUri: '${redirectUri}',
        );
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
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
Future<void> fetchToken(WidgetRef ref) async {
  Dio dio = Dio();
  // 카카오 로그인 로직으로 토큰 발급
  if (ref.read(kakaoTokenProvider) == null) {
    await kakaoLogin(ref);
  }
  // final String mobileId = await getMobileId();

  final String FCMToken = await getFCMToken() ?? '';
  // print('진짜토큰 $FCMToken');

  // 발급받은 카카오 토큰을 이용해 서버 로그인 요청
  try {
    Response response =
        await dio.post('http://k9e102.p.ssafy.io:8000/api/user/kakao-login',
            options: Options(
              headers: {
                'Authorization': 'Bearer ${ref.read(kakaoTokenProvider)}',
              },
            ),
            data: {'phoneId': FCMToken});

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
  } catch (e) {
    // 에러 처리
    throw Exception('서버 토큰을 가져오는데 실패했습니다: $e');
  }
}

// 서버 API로 정보 받아오는거임
Future<void> fetchProfile(WidgetRef ref) async {
  final loginState = ref.read(loginStateProvider);
  final token = loginState.serverToken;
  final id = loginState.id;

  var headers = {'Authorization': '$token', 'id': '$id'};

  // 서버 토큰이 없으면
  if (token == null) {
    await kakaoLogin(ref);
    await fetchToken(ref);

    // 토큰을 다시 읽습니다.
    final newToken = ref.read(loginStateProvider).serverToken;
    final newId = ref.read(loginStateProvider).id;

    headers['Authorization'] = '$newToken';
    headers['id'] = '$newId';
  }

  final apiService = ApiService();
  try {
    Response response = await apiService.sendRequest(
        method: 'GET', path: '/api/user/profile', headers: headers);

    // 여기서 회원 정보 프로바이더 저장 후 전달
    var user = UserState(
      profileImage: response.data['result'][0]['profileImage'] as String,
      nickName: response.data['result'][0]['nickName'] as String,
      privacy: response.data['result'][0]['privacy'] as String,
      stateMessage: response.data['result'][0]['stateMessage'] as String?,
    );

    ref.read(userStateProvider.notifier).setUserState(user);
    print('프로필 조회 끝 ${ref.read(userStateProvider)?.nickName}');
  } catch (e) {
    print(e);
  }
}

Future<void> widthdrawal(WidgetRef ref) async {
  final loginState = ref.read(loginStateProvider);
  final token = loginState.serverToken;
  final id = loginState.id;

  var headers = {'Authorization': '$token', 'id': '$id'};

  // 서버 토큰이 없으면
  if (token == null) {
    await kakaoLogin(ref);
    await fetchToken(ref);

    // 토큰을 다시 읽습니다.
    final newToken = ref.read(loginStateProvider).serverToken;
    final newId = ref.read(loginStateProvider).id;

    headers['Authorization'] = '$newToken';
    headers['id'] = '$newId';
  }

  final apiService = ApiService();
  try {
    await apiService.sendRequest(
        method: 'DELETE', path: '/api/user/withdrawal', headers: headers);
  } catch (e) {
    print(e);
  }
}
