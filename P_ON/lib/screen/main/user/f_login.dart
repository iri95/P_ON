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
import 'package:flutter/foundation.dart';

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
                color: (kIsWeb) ? Color(0xffffca38) : const Color(0xffF9E000)),
            child: TextButton(
              onPressed: () async {
                // FIXME: 이게 키해시임
                print("=====");
                // print(await KakaoSdk.origin);

                await goLogin();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (kIsWeb)
                      ? Ink()
                      : Ink(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/image/icon/kakao.png'),
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle),
                          width: 48,
                          height: 48,
                          child: InkWell(
                            onTap: () {},
                          ),
                        ),
                  (kIsWeb)
                      ? const Text('P:ON 미리보기',
                          style: TextStyle(
                              color: Color(0xff371C1D),
                              fontFamily: 'Pretendard',
                              fontSize: 24,
                              fontWeight: FontWeight.w700))
                      : const Text('카카오로 시작하기',
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
