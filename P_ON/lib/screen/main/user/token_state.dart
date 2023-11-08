import 'package:flutter_riverpod/flutter_riverpod.dart';

final kakaoTokenProvider = StateProvider<String?>((ref) => null);

// ====================================================================

// 로그인과 유저 상태
class LoginState {
  final String? role;
  final String? serverToken;
  final String? id;

  LoginState({this.role, this.serverToken, this.id});

  LoginState copyWith({
    String? role,
    String? serverToken,
    String? id,
  }) {
    return LoginState(
      role: role ?? this.role,
      serverToken: serverToken ?? this.serverToken,
      id: id ?? this.id,
    );
  }
}

// LoginState를 관리하는 StateNotifier
class LoginStateNotifier extends StateNotifier<LoginState> {
  LoginStateNotifier() : super(LoginState());

  // 로그인 상태 업데이트
  void setLoginState(LoginState loginState) {
    state = loginState;
  }

  // 각 값들을 개별적으로 업데이트하는 메서드들
  void updateRole(String? role) {
    state = state.copyWith(role: role);
  }

  void updateServerToken(String? serverToken) {
    state = state.copyWith(serverToken: serverToken);
  }

  void updateId(String? id) {
    state = state.copyWith(id: id);
  }

  // 상태 초기화
  void clear() {
    state = LoginState();
  }
}

// LoginStateNotifier를 사용하는 StateNotifierProvider
final loginStateProvider =
    StateNotifierProvider<LoginStateNotifier, LoginState>((ref) {
  return LoginStateNotifier();
});
