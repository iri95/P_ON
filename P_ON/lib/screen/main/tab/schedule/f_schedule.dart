import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:p_on/screen/main/fab/w_bottom_nav_floating_button.riverpod.dart';
import 'package:p_on/screen/main/tab/home/w_p_on_app_bar.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_server_url.dart';
import 'package:p_on/screen/main/tab/schedule/dto_schedule.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import 'package:p_on/screen/main/user/user_state.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleFragment extends ConsumerStatefulWidget {
  const ScheduleFragment({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleFragment> createState() => _CalendarFragmentState();
}

class _CalendarFragmentState extends ConsumerState<ScheduleFragment> {
  final scrollController = ScrollController();
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();

  final kToday = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List userList = [];
  List<dynamic>? userSchedule;
  bool isLoading = true;


  Future<Response> getUserListAndSchedule() async {
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;
    final userState = ref.read(userStateProvider);
    final myImage = userState?.profileImage;
    final myNick = userState?.nickName;

    // 현재 사용자 정보를 userList에 먼저 추가
    userList = [{
      'nickname': myNick,
      'profileImage': myImage,
      'userId': id
    }];

    var headers = {'Authorization': '$token', 'id': '$id'};

    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);

      // 토큰을 다시 읽습니다.
      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;

      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'GET',
          path: '$server/api/follow/following',
          headers: headers);

      if (response.statusCode == 200) {
        var rawData = response.data['result'] as List;
        print('팔로잉 데이터 : $rawData');
        print('팔로잉 목록조회');

        userList.addAll(rawData.map((item) {
          var followData = item['follow'];
          return {
            'nickname': followData['nickName'],
            'profileImage': followData['profileImage'],
            'userId': followData['id']
          };
        }).toList());

        print('변환된 userList : $userList');

        setState(() {});
      }
    } catch (e) {
      print(e);
    }

    List<int> userId = (userList ?? [])
        .map((user) => int.parse(user['userId'].toString()))
        .toList();
    String userIdList = userId.join(',');

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
        populateEventsForUserId(id as int);
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
    scrollController.addListener(() {
      final floatingState = ref.read(floatingButtonStateProvider);
      if (scrollController.position.pixels > 100 && !floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(true);
      } else if (scrollController.position.pixels < 100 && floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(false);
      }
    });

    super.initState();

    getUserListAndSchedule();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref를 사용하여 데이터를 설정
      ref.read(scheduleProvider.notifier).setScheduleStartDate(_focusedDay);
      ref.read(scheduleProvider.notifier).setScheduleEndDate(_focusedDay);
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      ref.read(scheduleProvider.notifier).setScheduleStartDate(selectedDay);
      ref.read(scheduleProvider.notifier).setScheduleEndDate(selectedDay);

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
      ref.read(scheduleProvider.notifier).setScheduleStartDate(start);
      ref.read(scheduleProvider.notifier).setScheduleEndDate(end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
      ref.read(scheduleProvider.notifier).setScheduleStartDate(start);
      ref.read(scheduleProvider.notifier).setScheduleEndDate(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
      ref.read(scheduleProvider.notifier).setScheduleStartDate(end);
      ref.read(scheduleProvider.notifier).setScheduleEndDate(end);
    }
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

    if (eventsForDay != null) {
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

    if (isLoading) {
      return CircularProgressIndicator();  // 로딩 표시
    }

    return Material(
      child: Column(
        children: [
          const PONAppBar(),
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: userList
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
                            populateEventsForUserId(item['userId']);
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
              firstDay: DateTime.utc(2012, 4, 16),
              lastDay: DateTime.utc(2033, 12, 14),
              focusedDay: _focusedDay,
              daysOfWeekHeight: 40.0,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
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
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
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
          const SizedBox(height: 8.0),
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xff3F48CC),
              backgroundColor: const Color(0xffFFBA20),
              // edgeOffset: PONAppBar.appBarHeight,
              onRefresh: () async {
                await sleepAsync(500.ms);
              },
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    controller: scrollController,
                    // 리스트가 적을때는 스크롤이 되지 않도록 기본 설정이 되어있는 문제해결.
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () => print('${value[index]}'),
                          title: Text('${value[index]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<DateTime> getDatesInRange(DateTime start, DateTime end) {
  List<DateTime> dates = [];
  for (int i = 0; i <= end.difference(start).inDays; i++) {
    dates.add(start.add(Duration(days: i)));
  }
  return dates;
}

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

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);
//
// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
//   ..addAll({
//     kToday: [
//       Event('Today\'s Event 1'),
//       Event('Today\'s Event 2'),
//     ],
//   });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}
 