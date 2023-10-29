import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/widget/w_list_container.dart';
import 'package:fast_app_base/common/widget/w_rounded_container.dart';
import 'package:fast_app_base/screen/dialog/d_message.dart';
import 'package:fast_app_base/screen/main/tab/home/w_my_plan_and_promise.dart';
import 'package:fast_app_base/screen/main/tab/home/w_p_on_app_bar.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/f_create_promise.dart';
import 'package:flutter/material.dart';

import '../../../../common/widget/w_big_button.dart';
import '../../../dialog/d_color_bottom.dart';
import '../../../dialog/d_confirm.dart';
import '../../s_main.dart';
import 'bank_accounts_dummy.dart';
import 'package:dio/dio.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: Stack(
        children: [
          RefreshIndicator(
            color: const Color(0xff3F48CC),
            backgroundColor: const Color(0xffFFBA20),
            edgeOffset: PONAppBar.appBarHeight,
            onRefresh: () async {
              await sleepAsync(500.ms);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: PONAppBar.appBarHeight + 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoundedContainer(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          '수완'
                              .text
                              .semiBold
                              .size(24)
                              .color(AppColors.mainBlue)
                              .make(),
                          '님,'
                              .text
                              .semiBold
                              .size(24)
                              .color(Colors.black)
                              .make(),
                        ],
                      ),
                      '다가오는 약속이 있어요!'
                          .text
                          .semiBold
                          .size(24)
                          .color(Colors.black)
                          .make(),
                    ], // 로그인한 유저 이름으로 변경하기
                  )),
                  RoundedContainer(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...planList.map((e) => MyPlanAndPromise(e)).toList()
                    ],
                  )),
                  height100
                ],
              ),
            ),
          ),
          const PONAppBar(),
          Positioned(
              bottom: 40,
              right: 10,
              child: FloatingActionButton(
                backgroundColor: const Color(0xffEFF3F9),
                elevation: 4,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatePromise())
                  );
                },
                child: Icon(
                  Icons.add,
                  color: context.appColors.navButton,
                ),
              ))
        ],
      ),
    );
  }
}
