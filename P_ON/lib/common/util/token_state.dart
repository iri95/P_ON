import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenStateNotifier extends StateNotifier<String?> {
  TokenStateNotifier() : super(null);

  void setToken(String? token) => state = token;

  void clearToken() => state = null;
}

final tokenProvider = StateNotifierProvider<TokenStateNotifier, String?>((ref) {
  return TokenStateNotifier();
});
