import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:flutter/material.dart';
import 'package:p_on/screen/main/fab/w_bottom_nav_floating_button.dart';
import 'package:p_on/screen/main/tab/benefit/history_scroll_provider/history_scroll_controller_provider.dart';
import 'package:p_on/screen/main/tab/home/w_p_on_app_bar.dart';
import 'package:p_on/common/widget/w_rounded_container.dart';
import 'package:p_on/screen/main/s_main.dart';
import 'package:p_on/screen/main/user/user_state.dart';

import 'w_my_complete_promise.dart';
import 'complete_provider.dart';

class BenefitFragment extends ConsumerStatefulWidget {
  const BenefitFragment({Key? key}) : super(key: key);

  @override
  ConsumerState<BenefitFragment> createState() => _BenefitFragmentState();
}

class _BenefitFragmentState extends ConsumerState<BenefitFragment> {
  late ScrollController scrollController;
  late var _user;

// 추억리스트 받아오기
  @override
  void initState() {
    print('추억');
    super.initState();
    ref.read(completeProvider.notifier).getCompleteRoom();
    scrollController = ref.read(historyScrollControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    scrollController = ref.watch(historyScrollControllerProvider);
    final completeData = ref.watch(completeProvider);
    int _completeCount = completeData.completeCount;

    _user = ref.watch(userStateProvider);

    return Material(
        child: Container(
      child: Stack(children: [
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
              children: [
                RoundedContainer(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        '${_user?.nickName ?? ''}'
                            .text
                            .fontWeight(FontWeight.w800)
                            .size(26)
                            .color(AppColors.mainBlue)
                            .make(),
                        '님 '.text.semiBold.size(24).color(Colors.black).make(),
                        '${_completeCount} 개'
                            .text
                            .fontWeight(FontWeight.w800)
                            .size(26)
                            .color(AppColors.mainBlue)
                            .make(),
                        '의'.text.semiBold.size(24).color(Colors.black).make(),
                      ],
                    ),
                    '저장된 추억이 있어요'
                        .text
                        .semiBold
                        .size(24)
                        .color(Colors.black)
                        .make(),
                  ],
                )),
                // 추억 약속방들

                const MyCompletePromise(),
                height100
              ],
            ),
          ),
        ),
        const PONAppBar(),
      ]),
    ));
  }
}
