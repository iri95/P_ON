import 'package:dio/dio.dart';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'token_state.dart';

class AuthService {
  Dio dio = Dio();
  final Ref ref;

  AuthService(this.ref) {
    dio.options.baseUrl = 'http://k9e102.p.ssafy.io:8000/api/user/kakao-login';
  }

  // 카카오 로그인을 통해 서버 토큰을 발급받는 함수
  Future<String> fetchToken() async {
    final storedToken = ref.read(tokenProvider);
    if (storedToken != null && storedToken.isNotEmpty) {
      return storedToken;
    }

    // 카카오 로그인 로직으로 토큰 발급
    final kakaoToken = await kakaoLogin();

    // 발급받은 카카오 토큰을 이용해 서버 로그인 요청
    try {
      Response response = await dio.post(
        '/api/user/kakao-login',
        options: Options(headers: {
          'Authorization': 'Bearer $kakaoToken',
        }),
      );

      final serverToken =
          response.headers.map['authorization']?.first; // 응답에서 서버 토큰 추출
      // dynamic serverId = response.headers.map['id']?.first;
      ref.read(tokenProvider.notifier).setToken(serverToken);
      print('서버토큰 ${serverToken} ================');
      return serverToken!;
    } catch (e) {
      // 에러 처리
      throw Exception('서버 토큰을 가져오는데 실패했습니다: $e');
    }
  }

  // 토큰 유효성 체크
  Future<void> isToken() async {
    // hasToken이 true: 기존에 발급받은 액세스 토큰 또는 리프레시 토큰이 존재
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공'
            '\n회원정보: ${tokenInfo.id}'
            '\n만료시간: ${tokenInfo.expiresIn} 초');
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
        // 카카오 로그인 -> 토큰 재발급 -> 서버 토큰 발급
        // await kakaoLogin();
        await fetchToken();
      }
    } else {
      print('발급된 토큰 없음');
      // await kakaoLogin();
      await fetchToken();
    }
  }

  // 카카오 로그인
  Future<String> kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 ${token.accessToken}');
        return token.accessToken;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          print('디바이스 권한 요청 화면에서 로그인을 취소한 경우');
          return '';
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오톡 계정 로그인 ${token.accessToken}');
          return token.accessToken;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return '';
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오톡 계정 로그인 ${token.accessToken}');
        return token.accessToken;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return '';
      }
    }
  }
}

class ApiService {
  Dio dio;
  final Ref ref;

  ApiService(this.ref, {Dio? dio}) : dio = dio ?? Dio() {
    this.dio.options.baseUrl = 'http://k9e102.p.ssafy.io:8000';
    // this.dio.options.connectTimeout = 5000; // 5초
    // this.dio.options.receiveTimeout = 3000; // 3초

    // 필요한 경우 인터셉터를 추가할 수 있습니다.
    this.dio.interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) async {
            // 요청이 전송되기 전에 여기서 무언가를 할 수 있습니다.

            // 현재 저장된 토큰을 가져옵니다.
            final token = ref.read(tokenProvider);
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            return handler.next(options); // 계속해서 요청을 전송합니다.
          },
          onResponse: (response, handler) {
            // 응답 데이터를 받은 후의 처리를 여기서 할 수 있습니다.
            return handler.next(response); // 계속해서 응답 데이터를 전달합니다.
          },
          onError: (DioError e, handler) async {
            // 에러가 발생했을 때의 처리를 여기서 할 수 있습니다.
            // 토큰 만료 에러를 여기서 처리할 수 있습니다.
            if (e.response?.statusCode == 401) {
              // 토큰 만료 시 로직
              // try {
              //   final newToken =
              //       await ref.read(authServiceProvider).fetchToken();
              //   final req = handler.requestOptions;
              //   req.headers['Authorization'] = 'Bearer $newToken';
              //   // 요청을 재시도
              //   final opts = Options(
              //     method: req.method,
              //     headers: req.headers,
              //   );
              //   final clonedReq = await dio.request(req.path, options: opts);
              //   return handler.resolve(clonedReq);
              // } catch (error) {
              //   return handler.next(e);
              // }
            } else {
              // 기타 에러 처리...
              return handler.next(e);
            }
          },
        ));
  }

  Future<Response> sendRequest({
    required String method,
    required String path,
    dynamic data,
  }) async {
    // 요청을 구성하기 위한 옵션 설정
    var options = Options(
      method: method,
    );

    try {
      // 요청을 보내고 응답을 받습니다.
      Response response = await dio.request(
        path,
        data: data,
        options: options,
      );
      return response; // 성공한 경우 응답을 반환합니다.
    } on DioError catch (e) {
      // DioError를 처리합니다.
      throw e; // 혹은 적절한 방법으로 에러를 처리합니다.
    }
  }
  // Future<Response> sendRequest({
  //   required String method,
  //   required String path,
  //   dynamic data,
  // }) async {
  //   // 요청을 구성하기 위한 옵션 설정
  //   var options = Options(
  //     method: method,
  //   );

  //   try {
  //     // 요청을 보내고 응답을 받습니다.
  //     Response response = await dio.request(
  //       path,
  //       data: data,
  //       options: options,
  //     );
  //     return response; // 성공한 경우 응답을 반환합니다.
  //   } on DioError catch (e) {
  //     // DioError를 처리합니다.
  //     throw e; // 혹은 적절한 방법으로 에러를 처리합니다.
  //   }
  // }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref);
});
