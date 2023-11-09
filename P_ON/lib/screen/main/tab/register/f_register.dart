import 'package:p_on/auth.dart';
import 'package:p_on/common/common.dart';
import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:velocity_x/velocity_x.dart';

import 'w_register_body.dart';

import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import 'package:p_on/screen/main/user/user_state.dart';
import 'package:go_router/go_router.dart';

class RegisterFragment extends ConsumerStatefulWidget {
  String nickName;
  String profileImage;
  String privacy;
  String? stateMessage;

  RegisterFragment({
    super.key,
    required this.nickName,
    required this.profileImage,
    required this.privacy,
    this.stateMessage,
  });

  @override
  ConsumerState<RegisterFragment> createState() => _RegisterFragmentState();
}

class _RegisterFragmentState extends ConsumerState<RegisterFragment> {
  // temp
  late String currentNickName;
  late String currentProfileImage;

  @override
  void initState() {
    super.initState();
    currentNickName = widget.nickName;
  }

  @override
  Widget build(BuildContext context) {
    void goToMainPage() async {
      // 'context'는 현재 위젯의 BuildContext입니다.
      GoRouter.of(context).go('/main');
    }

    Future<void> signUp() async {
      final loginState = ref.read(loginStateProvider);
      final token = loginState.serverToken;
      final id = loginState.id;
      var headers = {'Authorization': '$token', 'id': '$id'};
      if (token == null) {
        await kakaoLogin(ref);
        await fetchToken(ref);

        // 토큰을 다시 읽습니다.
        final newToken = ref.read(loginStateProvider).serverToken;
        final newId = ref.read(loginStateProvider).id;

        headers['Authorization'] = ' $newToken';
        headers['id'] = '$newId';
      }

      final apiService = ApiService();
      var newUser = UserState(
          profileImage: widget.profileImage,
          nickName: currentNickName,
          privacy: widget.privacy,
          stateMessage: widget.stateMessage);
      final data = {
        'profileImage': widget.profileImage,
        'nickName': currentNickName,
        'privacy': widget.privacy,
        'stateMessage': widget.stateMessage
      };

      // 바뀐 값으로 데이터를 저장, 요청
      ref.read(userStateProvider.notifier).setUserState(newUser);
      PonAuth().signInWithKakao(ref);
      try {
        Response response = await apiService.sendRequest(
            method: 'POST',
            path: '/api/user/sign-up',
            headers: headers,
            data: data);
        print(response);

        print('메인으로 ㄱㄱ');
        // TODO: 메인으로 라우팅 안됨
        PonAuth().signInWithKakao(ref);
        goToMainPage();
      } catch (e) {
        print(e);
      }
    }

    // TODO: 프로필 이미지를 S3로 전달

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Nav.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
              title: '회원가입'.text.black.make(),
              centerTitle: true,
            ),
          ),
        ),
        body: RegisterBody(
          nickName: widget.nickName,
          profileImage: widget.profileImage,
          onNickNameChanged: (newNickName) {
            // 이 부분에서 새로운 닉네임을 사용합니다.
            // 예를 들어, 상태 변수에 저장하거나, 다른 로직을 수행합니다.
            setState(() {
              currentNickName = newNickName;
            });
          },
        ),
        bottomSheet: Container(
          width: double.infinity,
          height: 48,
          margin: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          decoration: BoxDecoration(
              color: AppColors.mainBlue,
              borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () async {
              // 회원가입 로직 작성
              await signUp();
            },
            child: '확인'.text.semiBold.white.make(),
          ),
        ),
      ),
    );
  }
}
