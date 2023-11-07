import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/util/dio.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read);
});
