import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/constant/app_colors.dart';
import 'package:p_on/screen/main/tab/chat_room/dto_vote.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:go_router/go_router.dart';

class VoteItems extends ConsumerStatefulWidget {
  // 받아온 유저 id 값으로 수정버튼 보이거나 안보이거나 처리
  final String roomId;
  final String text;
  final String voteType;
  final List<dynamic>? voteData;

  const VoteItems(
      {super.key,
      required this.roomId,
      required this.text,
      required this.voteData,
      required this.voteType});

  @override
  ConsumerState<VoteItems> createState() => _VoteItemsState();
}

class _VoteItemsState extends ConsumerState<VoteItems> {
  Color _textColor = AppColors.grey400;
  String? dropdownValue;
  final List<bool> _checkboxValues =
      List.generate(5, (index) => false); // 체크박스 상태를 추적하는 리스트
  late NaverMapController _mapController;
  final isUpdate = true;

  String changeDate(String date) {
    DateTime chatRoomDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('yyyy-MM-dd (E)', 'ko_kr');
    String formatterDate = formatter.format(chatRoomDate);
    return formatterDate;
  }

  @override
  Widget build(BuildContext context) {
    print('여기는 투표 아이템 부분');
    print(ref.read(voteInfoProvider).is_anonymous);
    print(ref.read(voteInfoProvider).is_multiple_choice);
    print(ref.read(voteInfoProvider).dead_date);
    print(ref.read(voteInfoProvider).dead_time);
    print('여기는 투표 아이템 부분');

    final isAnonymous = ref.read(voteInfoProvider).is_anonymous;
    final isMultipleChoice = ref.read(voteInfoProvider).is_multiple_choice;

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
                            
                            if (isMultipleChoice == true) {
                              for (int j = 0; j < _checkboxValues.length; j++) {
                                if (i != j) {
                                  _checkboxValues[j] = false;
                                }
                              }
                            }
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
                              if (widget.voteType == 'date')
                                Text(changeDate(widget.voteData![i])),
                              if (widget.voteType == 'time')
                                Text('${widget.voteData![i]}'),
                              if (widget.voteType == 'location')
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
                                  // Map<String, dynamic>widget.voteData!['items'][i]['user'].map<DropdownMenuItem<String>>((String value) {
                                  //  return DropdownMenuItem<String> (
                                  //      value: value
                                  //    )
                                  // })
                                  items: <String>['User 1', 'User 2', 'User 3']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: <Widget>[
                                          const CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://example.com/user-profile.png'), // 이미지 URL
                                          ),
                                          const SizedBox(width: 10),
                                          Text(value),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                        LinearPercentIndicator(
                          padding: EdgeInsets.zero,
                          // percent: widget.voteData!['items'][i]['count'] / widget.userCount
                          percent: i / 10,
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
            child: TextButton(
                onPressed: () {
                  // 투표 post 요청 보내고 다시 get으로 이방 정보를 받아와야함 즉 새로고침 일어나야함 => setState에 넣으면 될듯
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.mainBlue,
                  ),
                  child: const Center(
                    child: Text(
                      '투표하기',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )),
          ),
          if (widget.voteType == 'date')
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.green,
              margin: EdgeInsets.fromLTRB(24, 0, 24, 24),
            ),
          if (widget.voteType == 'location' && widget.voteData != null && widget.voteData!.length > 0)
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
