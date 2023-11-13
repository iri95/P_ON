import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';

import '../promise_room/vo_server_url.dart';

class RightModal extends ConsumerStatefulWidget {
  int id;
  List<dynamic>? users;

  RightModal({super.key, required this.id, this.users});

  @override
  ConsumerState<RightModal> createState() => _RightModalState();
}

class _RightModalState extends ConsumerState<RightModal> {
  Future<Response> getUserSchedule() async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};

    // 서버 토큰이 없으면
    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);

      // 토큰을 다시 읽습니다.
      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;

      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }
    List<int> userId = (widget.users ?? []).map((user) => int.parse(user['userId'].toString())).toList();
    String userIdList = userId.join(',');

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
        method: 'GET',
        path: '$server/api/calendar/schedule/promise?userIdList=${userIdList}',
        headers: headers,
      );
      print('일정조회 성ㄱㅇ');
      print(response);
      return response;
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserSchedule();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.users);
    return Container(
        color: AppColors.mainBlue50,
        width: MediaQuery.of(context).size.width - 60,
        height: double.infinity,
        child: SafeArea(
            child: Column(
          children: [
            Text('${widget.id}'),
            Text('모두의 일정'),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.grey50),
              child: TableCalendar(
                locale: 'ko_KR',
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2018, 10, 22),
                lastDay: DateTime.utc(2030, 12, 9),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      DateFormat('yy년 MM월', locale).format(date),
                  titleTextStyle: const TextStyle(
                    fontSize: 20.0,
                    color: AppColors.mainBlue,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                  formatButtonVisible: false,
                  headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
                ),
                // eventLoader: ,
              ),
            ),
            FutureBuilder(
              future: getUserSchedule(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("...");
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final response = snapshot.data;
                  return Text('Data Loadded: ${response.data}');
                }
              }
            )
          ],
        )));
  }
}
