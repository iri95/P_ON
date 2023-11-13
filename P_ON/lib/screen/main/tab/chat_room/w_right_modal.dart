import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
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
import '../schedule/f_schedule.dart';

class RightModal extends ConsumerStatefulWidget {
  int id;
  List<dynamic>? users;

  RightModal({super.key, required this.id, this.users});

  @override
  ConsumerState<RightModal> createState() => _RightModalState();
}

class _RightModalState extends ConsumerState<RightModal> {
  List<dynamic>? userSchedule;
  Map<DateTime, List> events = {};

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
    List<int> userId = (widget.users ?? [])
        .map((user) => int.parse(user['userId'].toString()))
        .toList();
    String userIdList = userId.join(',');

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
        method: 'GET',
        path: '$server/api/calendar/schedule/promise?userIdList=${userIdList}',
        headers: headers,
      );
      print('일정조회 성ㄱㅇ');
      print(response.data['result']);
      userSchedule = await response.data['result'];
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
            FutureBuilder(
                future: getUserSchedule(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: double.infinity,
                      height: 330,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(10)),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final response = snapshot.data;
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.grey50),
                          child: TableCalendar(
                            locale: 'ko_KR',
                            focusedDay: DateTime.now(),
                            firstDay: DateTime.utc(2018, 10, 22),
                            lastDay: DateTime.utc(2030, 12, 9),
                            eventLoader: (day) {
                              return events?[day] ?? [];
                            },

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
                              headerPadding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: widget.users
                                    ?.map((item) => Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                height: 80,
                                                child: TextButton(
                                                    onPressed: () {
                                                      addCalendarMarker(item['userId']);
                                                    },
                                                    child: ClipOval(
                                                      child: Image.network(
                                                          item['profileImage'],
                                                          fit: BoxFit.cover),
                                                    )),
                                              ),
                                              Text(
                                                item['nickname'],
                                                style: const TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList() ??
                                [],
                          ),
                        )
                      ],
                    );
                  }
                })
          ],
        )));
  }

  void addCalendarMarker(id) {
    List<dynamic> selectedUserSchedule = userSchedule![0][id.toString()];
    for (var event in selectedUserSchedule) {
      DateTime startDate = DateTime.parse(event['startDate']);
      startDate = DateTime(startDate.year, startDate.month, startDate.day);
      // events 맵에 새로운 이벤트를 추가
      if (!events.containsKey(startDate)) {
        events[startDate] = [];  // 날짜에 해당하는 이벤트 목록을 초기화
      }
      events[startDate]?.add(event);  // 이벤트를 목록에 추가
    }
  }
}
