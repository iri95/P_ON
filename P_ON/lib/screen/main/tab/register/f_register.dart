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
  Future<void> signUp() async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': 'Bearer $token', 'id': '$id'};

    // 서버 토큰이 없으면
    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);

      // 토큰을 다시 읽습니다.
      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;

      headers['Authorization'] = 'Bearer $newToken';
      headers['id'] = 'Bearer $newId';
    }

    final apiService = ApiService();
    const data = {};
    try {
      Response response = await apiService.sendRequest(
          method: 'POST',
          path: '/api/user/sign-up',
          headers: headers,
          data: data);

      print(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            nickName: widget.nickName, profileImage: widget.profileImage),
        bottomSheet: Container(
          width: double.infinity,
          height: 48,
          margin: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          decoration: BoxDecoration(
              color: AppColors.mainBlue,
              borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () async {
              // TODO: 회원가입 로직 작성
              // await signUp();
              print('');
            },
            child: '확인'.text.semiBold.white.make(),
          ),
        ),
      ),
    );
  }
}
