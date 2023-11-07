import 'package:flutter/material.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/constant/app_colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class VoteItems extends StatefulWidget {
  String roomId;
  String text;

  VoteItems({super.key, required this.roomId, required this.text});

  @override
  State<VoteItems> createState() => _VoteItemsState();
}

class _VoteItemsState extends State<VoteItems> {
  Color _textColor = AppColors.grey400;
  String? dropdownValue;
  List<bool> _checkboxValues = List.generate(5, (index) => false); // 체크박스 상태를 추적하는 리스트


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: ExpansionTile(
        title: Text(widget.text, style: TextStyle(color: _textColor)),
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
              margin: EdgeInsets.symmetric(vertical: 2),
              child: ListTile(
                  title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: _checkboxValues[i],
                    onChanged: (bool? newValue) {
                      setState(() {
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
                      Container(
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
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://example.com/user-profile.png'), // 이미지 URL
                                        ),
                                        SizedBox(width: 10),
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
                        percent: 33 / 100,
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
            margin: EdgeInsets.only(top: 6, bottom: 30),
            child: TextButton(
                onPressed: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
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
