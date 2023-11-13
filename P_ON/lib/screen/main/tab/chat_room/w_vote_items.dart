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

  const VoteItems(
      {super.key,
      required this.roomId,
      required this.text,
      required this.voteData,
      required this.voteType,
      required this.count,
      required this.isDone,
      required this.voteCompletedNotifier});

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

  String changeDate(String date) {
    DateTime chatRoomDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('yyyy-MM-dd (E)', 'ko_kr');
    String formatterDate = formatter.format(chatRoomDate);
    return formatterDate;
  }

  Future<void> postVote(selectedItems) async {
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
      print(selectedItems);
      Response response = await apiService.sendRequest(
          method: 'POST',
          path: '$server/api/promise/vote',
          headers: {...headers, 'Content-Type': 'application/json'},
          data: data);
      print('저장성공');
      print(selectedItems);
      print('초기화');
      selectedItems.clear();
      print(selectedItems);
      widget.voteCompletedNotifier.value = true;
    } catch (e) {
      print(e);
    }
  }

  Future<void> putVote(selectedItems) async {
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(context.size);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAnonymous = ref.read(voteInfoProvider).is_anonymous;
    final isMultipleChoice = ref.read(voteInfoProvider).is_multiple_choice;
    final currentUser = ref.read(loginStateProvider).id;
    final createUser = ref.read(voteInfoProvider).create_user.toString();
    final voteUpdate = currentUser == createUser ? true : false;
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
            if (voteUpdate)
              TextButton(
                  onPressed: () {
                    final router = GoRouter.of(context);
                    router.go('/create/vote/${widget.roomId}/date/$isUpdate');
                  },
                  child: Container(
                    width: 55,
                    height: 25,
                    decoration: BoxDecoration(
                        color: AppColors.mainBlue,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                        child: Text('수정',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.bold))),
                  ))
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
                      onChanged: (bool? newValue) {
                        setState(() {
                          if (newValue == true) {
                            if (isMultipleChoice == false) {
                              for (int j = 0; j < _checkboxValues.length; j++) {
                                if (i != j) {
                                  _checkboxValues[j] = false;
                                }
                              }
                              selectedItems.clear();
                            }
                            selectedItems.add(widget.voteData![i]['itemId']);
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
                                              CircleAvatar(
                                                radius: 20,
                                                child: Image.network(
                                                  item['profileImage'],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(item['nickName']),
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
                          color: AppColors.mainBlue,
                        ),
                        child: TextButton(
                          onPressed: () {},
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
          if (widget.voteType == 'DATE')
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.green,
              margin: EdgeInsets.fromLTRB(24, 0, 24, 24),
            ),
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
          id: widget.voteData![i]['location'],
          position: NLatLng(double.parse(widget.voteData![i]['lat']),
              double.parse(widget.voteData![i]['lng'])));
      _markers.add(marker);
      _mapController.addOverlay(marker);
      marker.openInfoWindow(
          NInfoWindow.onMarker(id: marker.info.id, text: '${i + 1} 번'));
    }
  }
}
