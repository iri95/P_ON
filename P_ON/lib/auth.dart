// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import 'package:p_on/screen/main/user/user_state.dart';

import 'package:p_on/main.dart';
import 'package:p_on/screen/main/s_main.dart';
import 'package:p_on/screen/main/tab/tab_item.dart';

/// A mock authentication service.
class PonAuth extends ChangeNotifier {
  // 로그인 상태
  bool _signedIn = false;

  /// Whether user has signed in.
  bool get signedIn => _signedIn;

  // /// Signs in a user.
  // 로그인
  // 서버 토큰이 있으면, 카카오 로그인 -> 서버 토큰 발급 진행
  Future<bool> signInWithKakao(WidgetRef ref) async {
    // 로그인
    await kakaoLogin(ref);
    await fetchToken(ref);

    // fetch Token 하면 token, role이 담김
    final token = ref.read(loginStateProvider).serverToken;
    final role = ref.read(loginStateProvider).role;
    print('1 ${token}, ${role}');

    if (token != null && role == 'USER') {
      // await kakaoLogin(ref);
      // await fetchToken(ref);
      _signedIn = true;
      // 그러면 여기서 토큰으로 프로필을 저장하고 메인으로 이동해야 함
      print('${ref.read(userStateProvider)?.nickName}');
    } else if (token != null && role == 'GUEST') {
      // _signedIn = true;
      _signedIn = false;

      // registedIn = false;
    } else {
      _signedIn = false;
    }
    // 상태 변경을 리스너에게 알림
    notifyListeners();
    return _signedIn;
  }

  // 진짜 회원가입
  Future<bool> signUp() async {
    _signedIn = true;
    notifyListeners();

    return _signedIn;
  }

  // final container = ProviderContainer();

  Future<void> signOut() async {
    // 로그아웃 처리
    _signedIn = false;
    // container.read(currentTabProvider).state = TabItem.home;

    notifyListeners();

    // 앱 종료
    // SystemNavigator.pop();

    // TODO: 이거 하면 탭 초기화 안댐;;
    runAppAgain();
  }

  String? guard(BuildContext context, GoRouterState state) {
    // print('~~~~~~~~~~~~~~~~~~~~~~');
    // print(state.matchedLocation);

    // user이면, true, true
    // guest이면, true, false
    // 아무것도 아니면 false, false
    final bool signedIn = this.signedIn;
    final bool signingIn = state.matchedLocation == '/signin';

    // Go to /signin if the user is not signed in
    if (!signedIn && !signingIn) {
      // 회원이 아니고, 다른 페이지임
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
