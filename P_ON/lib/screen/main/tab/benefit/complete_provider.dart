import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';

class CompleteState extends StateNotifier<CompleteData> {
  final LoginState loginState;

  CompleteState(this.loginState)
      : super(CompleteData(complete: [], completeCount: 0));

  Future<void> getCompleteRoom() async {
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'GET', path: '/api/promise/room/complete', headers: headers);
      // print(response.data['result'][0]);
      List<dynamic> newComplete = await response.data['result'][0];
      int newCompleteCount = response.data['count'];
      state =
          CompleteData(complete: newComplete, completeCount: newCompleteCount);
    } catch (e) {
      print(e);
    }
  }
}

class CompleteData {
  final List<dynamic> complete;
  final int completeCount;

  CompleteData({required this.complete, required this.completeCount});
}

final completeProvider =
    StateNotifierProvider<CompleteState, CompleteData>((ref) {
  final loginState = ref.watch(loginStateProvider);

  return CompleteState(loginState);
});
