import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/widget/w_list_container.dart';
import 'package:fast_app_base/common/widget/w_rounded_container.dart';
import 'package:fast_app_base/screen/main/tab/home/vo/vo_bank_account.dart';
import 'package:flutter/material.dart';

class BankAccountWidget extends StatelessWidget {
  final BankAccount account;

  const BankAccountWidget(this.account, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          width: double.infinity,
          child: ListContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: '중간 평가'
                        .text
                        .black
                        .size(24)
                        .fontWeight(FontWeight.w700)
                        .make()),
                Row(children: [
                  '일시 | '.text.black.size(20).fontWeight(FontWeight.w500).make(),
                  '2023년 10월 20일 (금)'
                      .text
                      .black
                      .size(20)
                      .fontWeight(FontWeight.w500)
                      .make(),
                ]),
                Row(
                  children: [
                    '시간 | '.text.black.size(20).fontWeight(FontWeight.w500).make(),
                    '미정'.text.black.size(20).fontWeight(FontWeight.w500).make(),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFEFF3F9),
                          onPrimary: Color(0xFF3F48CC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          minimumSize: Size(100, 20), // 너비, 높이
                        ),
                        onPressed: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              '투표 생성'.text.size(14).make(),
                              Icon(Icons.arrow_forward_ios, size: 14),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        '장소 | '
                            .text
                            .black
                            .size(20)
                            .fontWeight(FontWeight.w500)
                            .make(),
                        '부산 SSAFY'
                            .text
                            .black
                            .size(20)
                            .fontWeight(FontWeight.w500)
                            .make(),
                      ],
                    ),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(0xffEFF3F9),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0),
                        child: IconButton(
                          icon: Icon(Icons.chat_bubble, size: 15),
                          color: Color(0xff3F48CC),
                          onPressed: () {
                            // 버튼 누르면 해당 채팅방으로 이동
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Positioned(
            right: 20,
            child: Image(
              image: AssetImage('assets/image/main/핑키2.png'),
              fit: BoxFit.contain,
              width: 60,
            )),
      ],
    );
    // 받아온 데이터에 미정 포함되면 투표생성 버튼 보여주기
  }
}
