import 'dart:collection';

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
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  int? selectedUserId;


  List<dynamic>? userSchedule;
  Map<DateTime, List> events = {};
  bool isLoading = true;
  Future<Response>? getUserScheduleFuture;  // Future 변수 추가



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
      var rawList = response.data['result'] as List<dynamic>; // Step 1
      var convertedList = <Map<int, List<Map<String, dynamic>>>>[];

      for (var rawItem in rawList) {
        var mapItem = <int, List<Map<String, dynamic>>>{};

        rawItem.forEach((key, value) {
          var intKey = int.tryParse(key) ?? 0;

          // value가 null이거나 빈 리스트인 경우 건너뜁니다.
          if (value == null || (value as List<dynamic>).isEmpty) {
            return;
          }

          var listValue = value as List<dynamic>;
          var mapList = listValue.map((item) => item as Map<String, dynamic>).toList();

          mapItem[intKey] = mapList;
        });

        if (mapItem.isNotEmpty) {
          convertedList.add(mapItem);
        }
      }
      print('일정조회 성ㄱㅇ');
      print(response.data['result']);
      setState(() {
        userSchedule = convertedList;
        print('유저스케줄 들어감? : ${userSchedule}');
        isLoading = false;  // 로딩 상태 업데이트
        populateEventsFromList(convertedList);
        selectedUserId = null;
      });
      return response;
    } catch (e) {
      setState(() {
        isLoading = false;  // 에러 발생 시에도 로딩 상태 업데이트
      });
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();

    getUserScheduleFuture = getUserSchedule();
    // getUserSchedule();
  }


  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void populateEventsFromList(List<Map<int, List<Map<String, dynamic>>>> data) {
    // kEvents 초기화
    kEvents.clear();

    for (var dayMap in data) {
      for (var day in dayMap.keys) {
        List<Map<String, dynamic>> events = dayMap[day]!;
        for (var event in events) {
          DateTime startDate = DateTime.parse(event['startDate']);
          DateTime endDate = DateTime.parse(event['endDate']);
          String nickName = event['nickName'];
          String type = event['type'];

          List<DateTime> datesInRange = getDatesInRange(startDate, endDate);
          for (var date in datesInRange) {
            if (kEvents.containsKey(date)) {
              kEvents[date]!.add(Event('$nickName $type'));
            } else {
              kEvents[date] = [Event('$nickName $type')];
            }
          }
        }
      }
    }
    print('======');
    print('======');
    print('======');
    print(kEvents);
  }

  void populateEventsForUserId(int key) {
    // kEvents 초기화
    print(key);
    print('kEvent 초기화 전: ${kEvents}');
    kEvents.clear();
    print('kEvent 초기화 후: ${kEvents}');
    print('유저스케줄 있나? : ${userSchedule}');

    // userSchedule에서 특정 키에 해당하는 데이터만 추출
    var eventsForDay = userSchedule?.firstWhere(
          (dayMap) => dayMap.containsKey(key),
      orElse: () => <int, List<Map<String, dynamic>>>{},
    );

    if (eventsForDay != null && eventsForDay[key] != null) {
      List<Map<String, dynamic>> events = eventsForDay[key]!;
      for (var event in events) {
        DateTime startDate = DateTime.parse(event['startDate']);
        DateTime endDate = DateTime.parse(event['endDate']);
        String nickName = event['nickName'];
        String type = event['type'];

        List<DateTime> datesInRange = getDatesInRange(startDate, endDate);
        for (var date in datesInRange) {
          if (kEvents.containsKey(date)) {
            kEvents[date]!.add(Event('$nickName $type'));
          } else {
            kEvents[date] = [Event('$nickName $type')];
          }
        }
      }
    }

    print('======');
    print('======');
    print('======');
    print('kEvent 변경 후: ${kEvents}');
    // 캘린더 위젯 갱신을 위해 setState 호출
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.users);

    if (isLoading) {
      return CircularProgressIndicator();  // 로딩 표시
    }

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
                future: getUserScheduleFuture,
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
                          height: 120,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: widget.users?.map((item) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedUserId = item['userId'];
                                    populateEventsForUserId(item['userId']);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedUserId = item['userId'];
                                              populateEventsForUserId(item['userId']);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: selectedUserId == item['userId'] ? Colors.blue : Colors.transparent,
                                                width: 4.0,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Image.network(
                                                item['profileImage'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item['nickname'],
                                        style: const TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList()??[],
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.all(8.0),
                          elevation: 5.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            side: BorderSide( color:Colors.black26, width: 1.0),
                          ),
                          child: TableCalendar<Event>(
                            locale: 'ko_KR',
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            focusedDay: _focusedDay,
                            daysOfWeekHeight: 40.0,
                            calendarFormat: _calendarFormat,
                            eventLoader: _getEventsForDay,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            calendarStyle: const CalendarStyle(
                              tablePadding: EdgeInsets.only(bottom: 8.0),
                              markerSize: 8.0,
                              // marker 여러개 일 때 cell 영역을 벗어날지 여부
                              canMarkersOverflow: false,
                              markerDecoration: BoxDecoration(
                                color: AppColors.calendarYellow,
                                shape: BoxShape.circle,
                                // shape: BoxShape.rectangle,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              titleCentered: true,
                              titleTextFormatter: (date, locale) => DateFormat('yy년 MM월', locale).format(date),
                              titleTextStyle: const TextStyle(
                                fontSize: 20.0,
                                color:  AppColors.mainBlue,
                              ),
                              formatButtonVisible: false,
                              headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
                            ),
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                          ),
                        ),
                        ElevatedButton(onPressed: (){
                          getUserSchedule();
                        },
                            child: Text('일정 새로고침'),)
                      ],
                    );
                  }
                })
          ],
        )));
  }
}

List<DateTime> getDatesInRange(DateTime start, DateTime end) {
  List<DateTime> dates = [];
  for (int i = 0; i <= end.difference(start).inDays; i++) {
    dates.add(start.add(Duration(days: i)));
  }
  return dates;
}

// 이벤트 맵 초기화
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);


class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}


int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}


final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 5, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year + 5, kToday.month + 3, kToday.day);

