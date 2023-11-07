// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// A mock authentication service.
class PonAuth extends ChangeNotifier {
  // 로그인 상태
  bool _signedIn = false;
  // KakaoToken? _kakaoToken;

  /// Whether user has signed in.
  bool get signedIn => _signedIn;
  // KakaoToken? get kakaoToken => _kakaoToken;

  // /// Signs in a user.
  // // 로그인
  // Future<bool> signIn(String username, String password) async {
  //   await Future<void>.delayed(const Duration(milliseconds: 200));

  //   // Sign in. Allow any password.
  //   _signedIn = true;
  //   notifyListeners();
  //   return _signedIn;
  // }

  // 카카오 로그인 및 토큰 발급
  Future<void> kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken kakaoToken = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 ${kakaoToken.accessToken}');
        _signedIn = true;
        notifyListeners(); // 로그인 상태 변경을 리스너에게 알림
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
          OAuthToken kakaoToken =
              await UserApi.instance.loginWithKakaoAccount();
          print('카카오톡 계정 로그인 ${kakaoToken.accessToken}');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return;
        }
      }
    } else {
      try {
        OAuthToken kakaoToken = await UserApi.instance.loginWithKakaoAccount();
        print('카카오톡 계정 로그인 ${kakaoToken.accessToken}');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return;
      }
    }
  }

  /// Signs out the current user.
  // 로그아웃
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  String? guard(BuildContext context, GoRouterState state) {
    final bool signedIn = this.signedIn;
    final bool signingIn = state.matchedLocation == '/signin';

    // Go to /signin if the user is not signed in
    if (!signedIn && !signingIn) {
      return '/signin';
    }
    // Go to /books if the user is signed in and tries to go to /signin.
    else if (signedIn && signingIn) {
      return '/';
    }

    // no redirect
    return null;
  }
}

/// An inherited notifier to host [PonAuth] for the subtree.
class PonAuthScope extends InheritedNotifier<PonAuth> {
  /// Creates a [PonAuthScope].
  const PonAuthScope({
    required PonAuth super.notifier,
    required super.child,
    super.key,
  });

  /// Gets the [PonAuth] above the context.
  static PonAuth of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PonAuthScope>()!.notifier!;
}
