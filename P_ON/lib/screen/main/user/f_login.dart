import 'package:after_layout/after_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:p_on/auth.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_server_url.dart';
import 'package:p_on/screen/main/tab/register/f_register.dart';
import 'package:flutter/material.dart';

import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import 'package:p_on/screen/main/user/user_state.dart';

import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with AfterLayoutMixin<LoginPage> {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final auth = PonAuthScope.of(context);

    // Future<void> fetchProfile() async {
    //   final loginState = ref.read(loginStateProvider);
    //   final token = loginState.serverToken;
    //   final id = loginState.id;

    //   var headers = {'Authorization': '$token', 'id': '$id'};

    //   // 서버 토큰이 없으면
    //   if (token == null) {
    //     await kakaoLogin(ref);
    //     await fetchToken(ref);

    //     // 토큰을 다시 읽습니다.
    //     final newToken = ref.read(loginStateProvider).serverToken;
    //     final newId = ref.read(loginStateProvider).id;

    //     headers['Authorization'] = '$newToken';
    //     headers['id'] = '$newId';
    //   }

    //   final apiService = ApiService();
    //   try {
    //     Response response = await apiService.sendRequest(
    //         method: 'GET', path: '/api/user/profile', headers: headers);

    //     // 여기서 회원 정보 프로바이더 저장 후 전달
    //     var user = UserState(
    //       profileImage: response.data['result'][0]['profileImage'] as String,
    //       nickName: response.data['result'][0]['nickName'] as String,
    //       privacy: response.data['result'][0]['privacy'] as String,
    //       stateMessage: response.data['result'][0]['stateMessage'] as String?,
    //     );

    //     ref.read(userStateProvider.notifier).setUserState(user);
    //     print('여긴 로그인이고 프로필 조회 끝 ${ref.read(userStateProvider)?.nickName}');
    //   } catch (e) {
    //     print('여긴 로그인이고 프로필 에러 $e');
    //   }
    // }

    Future<void> goLogin() async {
      // 여기서 user이면, 바로 true로 변하고 이동 바로됨
      await auth.signInWithKakao(ref);

      // role이 user이면 회원, guest이면 비회원
      // 비회원이면, 회원 가입으로
      if (ref.read(loginStateProvider).role == 'GUEST') {
        print('난 게스트고 가입으로');
        await fetchProfile(ref);
        // 저장된 userState
        final userState = ref.watch(userStateProvider);
        await Nav.push(RegisterFragment(
          nickName: userState?.nickName ?? "",
          profileImage: userState?.profileImage ?? "",
          privacy: userState?.privacy ?? "ALL",
          stateMessage: userState?.stateMessage ?? "",
        ));

        // GoRouter.of(context).go('/register', extra: {
        //   'nickName': userState?.nickName ?? "",
        //   'profileImage': userState?.profileImage ?? "",
        //   'privacy': userState?.privacy ?? "PRIVATE / ALL",
        //   'stateMessage': userState?.stateMessage ?? "",
        // });
      } else {
        // 회원이면 메인 페이지로
        print('난 유저고 메인으로 ${auth.signedIn}');
      }
    }

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
                // FIXME: 이게 키해시임
                // print("=====");
                // print(await KakaoSdk.origin);

                await goLogin();
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
