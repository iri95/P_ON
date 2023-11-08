import 'package:flutter/material.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/constant/app_colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:go_router/go_router.dart';

class VoteItems extends StatefulWidget {
  // 받아온 유저 id 값으로 수정버튼 보이거나 안보이거나 처리
  final String roomId;
  final String text;
  // final Map<String, dynamic>voteDate;

  const VoteItems({super.key, required this.roomId, required this.text});//, required this.voteDate});

  @override
  State<VoteItems> createState() => _VoteItemsState();
}

class _VoteItemsState extends State<VoteItems> {
  Color _textColor = AppColors.grey400;
  String? dropdownValue;
  final List<bool> _checkboxValues = List.generate(5, (index) => false); // 체크박스 상태를 추적하는 리스트
  final isUpdate = true;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(widget.text, style: TextStyle(color: _textColor, fontSize: 20, fontFamily: 'Pretendard', fontWeight: FontWeight.bold)),
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
                  borderRadius: BorderRadius.circular(20)
                      
                ),
                child: const Center(child: Text('수정', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.bold))),
              )
            )
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
          for (int i = 0; i < 5; i++)
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
                          // voteDate.isMultipleChoice == false 조건 추가
                          for (int j = 0; j < _checkboxValues.length; j++) {
                            if (i != j) {
                              _checkboxValues[j] = false;
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
                            Text('$i번째 i'),
                            Expanded(child: Container()),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                onChanged: (String? newValue) {},
                                items: <String>[
                                  'User 1',
                                  'User 2',
                                  'User 3'
                                ].map<DropdownMenuItem<String>>((String value) {
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
          )
        ],
      ),
    );
  }
}
