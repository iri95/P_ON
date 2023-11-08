import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/widget/w_list_container.dart';
import 'package:p_on/common/widget/w_rounded_container.dart';
import 'package:p_on/screen/dialog/d_message.dart';
import 'package:p_on/screen/main/tab/home/w_my_plan_and_promise.dart';
import 'package:p_on/screen/main/tab/home/w_p_on_app_bar.dart';
import 'package:p_on/screen/main/tab/promise_room/f_create_promise.dart';
import 'package:flutter/material.dart';

import '../../../../common/widget/w_big_button.dart';
import '../../../dialog/d_color_bottom.dart';
import '../../../dialog/d_confirm.dart';
import '../../fab/w_bottom_nav_floating_button.dart';
import '../../fab/w_bottom_nav_floating_button.riverpod.dart';
import '../../s_main.dart';
import 'bank_accounts_dummy.dart';
import 'package:dio/dio.dart';

class HomeFragment extends ConsumerStatefulWidget {
  const HomeFragment({super.key});

  @override
  ConsumerState<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends ConsumerState<HomeFragment> {
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      final floatingState = ref.read(floatingButtonStateProvider);

      if (scrollController.position.pixels > 100 && !floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(true);
      } else if (scrollController.position.pixels < 100 &&
          floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(false);
      }
    });
    super.initState();
  }

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
                bottom: BottomFloatingActionButton.height,
              ),
              // 반응형으로 만들기위해서 컨트롤넣음
              controller: scrollController,
              // 리스트가 적을때는 스크롤이 되지 않도록 기본 설정이 되어있는 문제해결.
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 멘트
                  RoundedContainer(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TODO: User 닉네임 받아서 이름 넣기
                          '수완'
                              .text
                              .fontWeight(FontWeight.w800)
                              .size(26)
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
                  // 약속방들
                  Container(
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
        ],
      ),
    );
  }
}
