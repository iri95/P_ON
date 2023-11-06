import 'package:flutter/material.dart';
import 'package:p_on/common/common.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SelectVote extends StatefulWidget {
  const SelectVote({super.key});

  @override
  State<SelectVote> createState() => _SelectVoteState();
}

class _SelectVoteState extends State<SelectVote> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey)
              )
            ),
            child: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black
                ),
                onPressed: () {},
              ),
              title: const Text('투표하기',
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: Colors.black
              )),
              centerTitle: true,
              elevation: 0,
            ),
          ),
        ),
        body: Column(
          children: [
            // 받아온 데이터 보여주기

            Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.mainBlue3
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  // Checkbox(value: value, onChanged: onChanged)
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '받아온 데이터 타입에 따른 투표이름',
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Expanded(child: Container()),
                          // DropdownMenu(dropdownMenuEntries: dropdownMenuEntries)
                        ],
                      ),
                      // LinearPercentIndicator()
                    ],
                  )

                ],
              ),

            ),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.mainBlue, // 라디오 버튼 선택 여부에 따라 버튼 활성화 비활성화 하기
                borderRadius: BorderRadius.circular(5)
              ),
              child: TextButton(
                child: Text('투표하기'),
                onPressed: () {},
              ),
            )


          ],
        ),
      ),
    );
  }
}
