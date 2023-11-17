import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/constant/app_colors.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:p_on/screen/main/tab/chat_room/dto_vote.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../user/fn_kakao.dart';
import '../promise_room/vo_server_url.dart';

class VoteItems extends ConsumerStatefulWidget {
  // 받아온 유저 id 값으로 수정버튼 보이거나 안보이거나 처리
  final String roomId;
  final String text;
  final String voteType;
  final List<dynamic>? voteData;
  final int? count;
  final bool isDone;
  final ValueNotifier<bool> voteCompletedNotifier;
  final String voteInfo;

  const VoteItems({
    super.key,
    required this.roomId,
    required this.text,
    required this.voteData,
    required this.voteType,
    required this.count,
    required this.isDone,
    required this.voteCompletedNotifier,
    required this.voteInfo,
  });

  @override
  ConsumerState<VoteItems> createState() => _VoteItemsState();
}

class _VoteItemsState extends ConsumerState<VoteItems> {
  Color _textColor = AppColors.grey400;
  String? dropdownValue;
  final List<bool> _checkboxValues = List.generate(100, (index) => false);
  late NaverMapController _mapController;
  final isUpdate = true;
  List<dynamic> selectedItems = [];
  bool? isComplete = false;
  bool isVoteComplete = false;
  List<dynamic> userList = [];
  bool isLoading = true;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  final kToday = DateTime.now();

  String changeDate(String date) {
    DateTime chatRoomDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('yyyy-MM-dd (E)', 'ko_kr');
    String formatterDate = formatter.format(chatRoomDate);
    return formatterDate;
  }

  Future<Response> getVote() async {
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

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'GET',
          path: '$server/api/promise/vote/${widget.roomId}',
          headers: headers);
      // print('이거 위젯안에서 한번더 조회하는거임');
      // print('이거 위젯안에서 한번더 조회하는거임');
      // print('이거 위젯안에서 한번더 조회하는거임');
      // print(response);
      switch (widget.voteType) {
        case 'DATE':
          // print('여기는 date');
          // print(widget.voteType);
          isComplete = await response.data['result'][0]['dateComplete'];
          break;
        case 'TIME':
          // print('여기는 time');
          // print(widget.voteType);
          isComplete = await response.data['result'][0]['timeComplete'];
          break;
        case 'LOCATION':
          // print('여기는 location');
          // print(widget.voteType);
          isComplete = await response.data['result'][0]['locationComplete'];
          break;
        default:
          break;
      }
    } catch (e) {
      print(e);
    }
    try {
      Response response = await apiService.sendRequest(
          method: 'GET',
          path: '$server/api/promise/room/${widget.roomId}',
          headers: headers);
      userList = await response.data['result'][0]['users'];

      setState(() {});
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
          var mapList =
              listValue.map((item) => item as Map<String, dynamic>).toList();

          mapItem[intKey] = mapList;
        });

        if (mapItem.isNotEmpty) {
          convertedList.add(mapItem);
        }
      }
      // print('일정조회 성ㄱㅇ');
      // print(response.data['result']);
      setState(() {
        // print('컨버티드 리스트 만들어짐? : $convertedList');
        isLoading = false; // 로딩 상태 업데이트
        populateEventsFromList(convertedList);
      });
      return response;
    } catch (e) {
      setState(() {
        isLoading = false; // 에러 발생 시에도 로딩 상태 업데이트
      });
      throw e;
    }
  }

  Future<void> postVote(selectedItems) async {
    isVoteComplete = true;
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
    var data = {'itemList': selectedItems};

    final apiService = ApiService();
    try {
      // print(selectedItems);
      Response response = await apiService.sendRequest(
          method: 'POST',
          path: '$server/api/promise/vote',
          headers: {...headers, 'Content-Type': 'application/json'},
          data: data);
      // print('저장성공');
      // print(selectedItems);
      // print('초기화');
      selectedItems.clear();
      // print(selectedItems);
      widget.voteCompletedNotifier.value = true;
    } catch (e) {
      print(e);
    }
  }

  Future<void> putVote(selectedItems) async {
    isVoteComplete = false;
    for (int i = 0; i < widget.voteData!.length; i++) {
      _checkboxValues[i] = false;
    }
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

    var data = {
      'roomId': int.parse(widget.roomId),
      'itemType': widget.voteType,
      'itemList': selectedItems
    };
    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'PUT',
          path: '$server/api/promise/vote',
          headers: {...headers, 'Content-Type': 'application/json'},
          data: data);
      print(response);
      selectedItems.clear();
      widget.voteCompletedNotifier.value = true;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteVote() async {
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
    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
        method: 'DELETE',
        path: '$server/api/promise/item/${widget.roomId}/${widget.voteType}',
        headers: {...headers, 'Content-Type': 'application/json'},
      );
      final router = GoRouter.of(context);
      router.go('/chatroom/${widget.roomId}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> doneVote() async {
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
    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'PUT',
          path: '/api/promise/item/${widget.roomId}/${widget.voteType}',
          headers: headers);
      // print(response);
      final router = GoRouter.of(context);
      router.push('/chatroom/${widget.roomId}');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getVote();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(context.size);
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  // 하나만 찍으려고 로직 바꿈
  void populateEventsFromList(List<Map<int, List<Map<String, dynamic>>>> data) {
    // LinkedHashMap 초기화
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
            // 이미 해당 날짜에 이벤트가 있는 경우 추가하지 않음
            if (!kEvents.containsKey(date)) {
              kEvents[date] = [Event('$nickName $type')];
            }
          }
        }
      }
    }

    // print('======');
    // print('======');
    // print('======');
    // print(kEvents);
  }

  @override
  Widget build(BuildContext context) {
    final isAnonymous = ref.read(voteInfoProvider).is_anonymous;
    final isMultipleChoice = ref.read(voteInfoProvider).is_multiple_choice;
    final currentUser = ref.read(loginStateProvider).id;
    final createUser = ref.read(voteInfoProvider).create_user.toString();
    final voteUpdate = currentUser == createUser ? true : false;
    // print('===================');
    // print(isComplete);
    // print(widget.voteType);

    if (isLoading) {
      return Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(widget.text,
                style: TextStyle(
                    color: _textColor,
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold)),
            Expanded(child: Container()),
            if (widget.voteData != null &&
                widget.voteData!.length > 0 &&
                voteUpdate == true)
              PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => <PopupMenuEntry<int>>[
                        if (widget.isDone == false)
                          const PopupMenuItem(
                            textStyle: TextStyle(color: AppColors.grey500),
                            value: 1,
                            child: Center(child: Text('수정')),
                          ),
                        if (widget.isDone == false) const PopupMenuDivider(),
                        const PopupMenuItem(
                          textStyle: TextStyle(color: AppColors.grey500),
                          value: 2,
                          child: Center(child: Text('삭제')),
                        ),
                      ],
                  onSelected: (value) {
                    if (value == 1) {
                      final router = GoRouter.of(context);
                      router.go(
                          '/create/vote/${widget.roomId}/${widget.voteType}/$isUpdate/${widget.voteInfo}');
                    } else if (value == 2) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.zero,
                          content: Stack(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    decoration: const BoxDecoration(
                                      color: AppColors.mainBlue2,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Nav.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 24, bottom: 12),
                                    child: const Text(
                                      '투표를 삭제하시겠어요?',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: const Text(
                                      '삭제된 투표는 복구되지 않아요!',
                                      style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 14),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              Nav.pop(context);
                                            },
                                            child: const Text(
                                              '취소',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Pretendard',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.mainBlue2,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: TextButton(
                                            onPressed: () {
                                              deleteVote();
                                              Nav.pop(context);
                                            },
                                            child: const Text(
                                              '삭제',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Pretendard'),
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                top: 30,
                                left: 30,
                                child: Image.asset(
                                  'assets/image/main/핑키4.png',
                                  width: 48,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
          ],
        ),
        backgroundColor: AppColors.grey100,
        // 확장 시 배경 색상 변경
        initiallyExpanded: true,
        iconColor: AppColors.mainBlue3,
        onExpansionChanged: (expanded) {
          setState(() {
            if (expanded) {
              _textColor = AppColors.mainBlue3;
            } else {
              _textColor = AppColors.grey400;
            }
          });
        },
        children: [
          if (widget.voteData != null)
            for (int i = 0; i < widget.voteData!.length; i++)
              (Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: ListTile(
                    title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                      value: _checkboxValues[i],
                      onChanged: widget.isDone
                          ? null
                          : isVoteComplete
                              ? null
                              : (bool? newValue) {
                                  setState(() {
                                    if (newValue == true) {
                                      if (isMultipleChoice == false) {
                                        for (int j = 0;
                                            j < _checkboxValues.length;
                                            j++) {
                                          if (i != j) {
                                            _checkboxValues[j] = false;
                                          }
                                        }
                                        selectedItems.clear();
                                      }
                                      selectedItems
                                          .add(widget.voteData![i]['itemId']);
                                    } else {
                                      selectedItems.remove(widget.voteData![i]);
                                    }
                                    _checkboxValues[i] = newValue!;
                                  });
                                },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      checkColor: Colors.white,
                      activeColor: AppColors.mainBlue,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 80,
                          child: Row(
                            children: [
                              if (widget.voteType == 'DATE')
                                Text(changeDate(widget.voteData![i]['date'])),
                              if (widget.voteType == 'TIME')
                                Text('${widget.voteData![i]['time']}'),
                              if (widget.voteType == 'LOCATION')
                                InkWell(
                                  child: Text(
                                      '${widget.voteData![i]['location']}'),
                                  onTap: () {
                                    _mapController.updateCamera(
                                        NCameraUpdate.withParams(
                                            target: _markers[i].position,
                                            zoom: 15));
                                  },
                                ),
                              Expanded(child: Container()),
                              if (isAnonymous == false)
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    onChanged: (String? newValue) {},
                                    items: widget.voteData![i]['users']
                                        .map<DropdownMenuItem<String>>((item) {
                                      return DropdownMenuItem<String>(
                                        value: item['nickName'],
                                        child: Container(
                                          padding: EdgeInsets.zero,
                                          child: Row(
                                            children: [
                                              ClipOval(
                                                child: Image.network(
                                                  item['profileImage'],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20),
                                                child: Text(
                                                  item['nickName'],
                                                  style: const TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        LinearPercentIndicator(
                          padding: EdgeInsets.zero,
                          // percent: widget.voteData!['items'][i]['count'] / widget.userCount
                          percent: widget.voteData![i]['users'].length /
                              widget.count!,
                          lineHeight: 3,
                          backgroundColor: const Color(0xffCACFD8),
                          progressColor: AppColors.mainBlue2,
                          width: MediaQuery.of(context).size.width - 80,
                        ),
                      ],
                    )
                  ],
                )),
              )),
          if (widget.voteData != null && widget.voteData!.length > 0)
            Container(
              margin: const EdgeInsets.only(top: 6, bottom: 30),
              child: Row(
                children: [
                  if (isComplete! == false)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: widget.isDone
                              ? AppColors.mainBlue3
                              : AppColors.mainBlue,
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              widget.isDone
                                  ? putVote(selectedItems)
                                  : postVote(selectedItems);
                            });
                          },
                          child: Text(
                            widget.isDone ? '다시투표하기' : '투표하기',
                            style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  if (voteUpdate == true && widget.isDone == true)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isComplete!
                              ? AppColors.mainBlue50
                              : AppColors.mainBlue,
                        ),
                        child: TextButton(
                          onPressed: () async {
                            isComplete! ? null : await doneVote();
                          },
                          child: const Text(
                            '투표종료',
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),

          /// TODO : 여기 캘린더 넣어, 일정 마커 추가된것만
          /// 초록창 부분
          if (widget.voteType == 'DATE')
            Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 5.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                side: BorderSide(color: Colors.black26, width: 1.0),
              ),
              child: TableCalendar<Event>(
                locale: 'ko_KR',
                firstDay: DateTime.utc(2012, 4, 16),
                lastDay: DateTime.utc(2033, 12, 14),
                focusedDay: _focusedDay,
                daysOfWeekHeight: 40.0,
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarBuilders: CalendarBuilders<Event>(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          'X',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  },
                ),
                calendarStyle: const CalendarStyle(
                  tablePadding: EdgeInsets.only(bottom: 8.0),
                  markerSize: 16.0,
                  //   // marker 여러개 일 때 cell 영역을 벗어날지 여부
                  canMarkersOverflow: false,
                  //   markerDecoration: BoxDecoration(
                  //     color: AppColors.calendarYellow,
                  //     shape: BoxShape.circle,
                  //     // shape: BoxShape.rectangle,
                  //   ),
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      DateFormat('yy년 MM월', locale).format(date),
                  titleTextStyle: const TextStyle(
                    fontSize: 20.0,
                    color: AppColors.mainBlue,
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

          /// 여기까지 입니다
          /// 이 사이에 모두의 일정이 포함된 공유 캘린더 넣어 주시면 되용
          if (widget.voteType == 'LOCATION' &&
              widget.voteData != null &&
              widget.voteData!.length > 0)
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.blue,
              margin: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: NaverMap(
                options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                        target: NLatLng(
                            double.parse(widget.voteData![0]['lat']),
                            double.parse(widget.voteData![0]['lng'])),
                        zoom: 12)),
                onMapReady: (controller) {
                  _mapController = controller;
                  addMarker();
                },
              ),
            )
        ],
      ),
    );
  }

  List<NMarker> _markers = [];

  addMarker() {
    for (int i = 0; i < widget.voteData!.length; i++) {
      var marker = NMarker(
          id: 'marker_$i',
          position: NLatLng(double.parse(widget.voteData![i]['lat']),
              double.parse(widget.voteData![i]['lng'])));
      _markers.add(marker);
      _mapController.addOverlay(marker);
      marker.openInfoWindow(
          NInfoWindow.onMarker(id: marker.info.id, text: '${i + 1} 번'));
    }
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
