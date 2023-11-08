import 'package:dio/dio.dart';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';

class ApiService {
  Dio dio;

  ApiService({Dio? dio}) : dio = dio ?? Dio() {
    this.dio.options.baseUrl = 'http://k9e102.p.ssafy.io:8000';
    // this.dio.options.connectTimeout = 5000; // 5초
    // this.dio.options.receiveTimeout = 3000; // 3초

    // 필요한 경우 인터셉터를 추가할 수 있습니다.
    this.dio.interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) async {
            // 요청이 전송되기 전에 여기서 무언가를 할 수 있습니다.
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
    Map<String, dynamic>? headers,
  }) async {
    // 요청을 구성하기 위한 옵션 설정
    var options = Options(method: method, headers: headers);

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
}

// final apiServiceProvider = Provider<ApiService>((ref) {
//   return ApiService(ref);
// });
