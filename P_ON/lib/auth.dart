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

// 로그인 상태 파악

/// A mock authentication service.
class PonAuth extends ChangeNotifier {
  bool _signedIn = true;

  /// Whether user has signed in.
  bool get signedIn => _signedIn;

  /// Signs out the current user.
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  /// Signs in a user.
  Future<bool> signIn(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Sign in. Allow any password.
    _signedIn = true;
    notifyListeners();
    return _signedIn;
  }

  String? guard(BuildContext context, GoRouterState state) {
    final bool signedIn = this.signedIn;
    final bool signingIn = state.matchedLocation == '/signin';
    final bool registeringIn = state.matchedLocation == '/register';

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
