import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String profileImage;
  final String nickName;
  final String privacy;
  final String? stateMessage;

  UserState({
    required this.profileImage,
    required this.nickName,
    required this.privacy,
    this.stateMessage,
  });
}

// UserState를 관리하는 StateNotifier를 정의합니다.
class UserStateNotifier extends StateNotifier<UserState?> {
  UserStateNotifier()
      : super(UserState(
          profileImage: '',
          nickName: '',
          privacy: '',
        ));

  void setUserState(UserState userState) {
    state = userState;
  }
}

// UserStateNotifier를 사용하는 StateNotifierProvider를 정의합니다.
final userStateProvider =
    StateNotifierProvider<UserStateNotifier, UserState?>((ref) {
  return UserStateNotifier();
});
