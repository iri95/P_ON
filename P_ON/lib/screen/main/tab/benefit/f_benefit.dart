import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:flutter/material.dart';
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
  late var _user;

// 추억리스트 받아오기

  @override
  void initState() {
    print('추억');
    ref.read(completeProvider.notifier).getCompleteRoom();
    super.initState();
  }

// TODO: 여기도 끌어서 새로고침이랑, 탭 클릭 시 맨 위로 올라가게 해줘
  @override
  Widget build(BuildContext context) {
    final completeData = ref.watch(completeProvider);
    int _completeCount = completeData.completeCount;

    _user = ref.watch(userStateProvider);

    return Material(
        child: Column(children: [
      const PONAppBar(),
      Expanded(
          child: SingleChildScrollView(
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
                '저장된 추억이 있어요'.text.semiBold.size(24).color(Colors.black).make(),
              ],
            )),
            // 추억 약속방들

            const MyCompletePromise(),
            // const MyPlanAndPromise(),
            height100
          ],
        ),
      ))
    ]));
  }
}
