// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

// 로긍니 상태 파악
//

/// A mock authentication service.
class PonAuth extends ChangeNotifier {
  // 로그인 상태
  bool _signedIn = false;
  // KakaoToken? _kakaoToken;

  /// Whether user has signed in.
  bool get signedIn => _signedIn;
  // KakaoToken? get kakaoToken => _kakaoToken;

  // /// Signs in a user.
  // 로그인
  Future<bool> signIn(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Sign in. Allow any password.
    _signedIn = true;
    notifyListeners();
    return _signedIn;
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
