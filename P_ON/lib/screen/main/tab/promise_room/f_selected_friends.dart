import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/widget/w_basic_appbar.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/dto_promise.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/friends_dummy.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/w_follows.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/w_friends_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

class SelectedFriends extends ConsumerStatefulWidget {
  const SelectedFriends({super.key});

  @override
  ConsumerState<SelectedFriends> createState() => _SelectedFriendsState();
}

class _SelectedFriendsState extends ConsumerState<SelectedFriends> {
  @override
  Widget build(BuildContext context) {
    final promise = ref.watch(promiseProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const BasicAppBar(
                  text: '약속 생성', isProgressBar: true, percentage: 66),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                alignment: Alignment.topLeft,
                child:
                    '약속을 함께 할 친구를 추가해주세요'.text.black.size(16).semiBold.make(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 62,
                      margin: EdgeInsets.only(left: 32, right: 16),
                      decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          style: TextButton.styleFrom(primary: Colors.black),
                          onPressed: () {},
                          child: const Column(
                            children: [Icon(Icons.search), Text('닉네임 검색')],
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 62,
                      margin: EdgeInsets.only(left: 16, right: 32),
                      decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          style: TextButton.styleFrom(primary: Colors.black),
                          onPressed: () {},
                          child: const Column(
                            children: [Icon(Icons.link), Text('링크 복사')],
                          )),
                    ),
                  )
                ],
              ),
              Container(
                height: 120,
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(color: AppColors.grey200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '선택된 친구 ${promise.selected_friends?.length ?? 0}명'
                        .text
                        .semiBold
                        .size(16)
                        .make(),
                    Expanded(
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...friendList
                                .map((friend) => FriendsList(friend))
                                .toList()
                          ]),
                    ),
                  ],
                ),
              ),
              const Expanded(child: Follows()),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            width: double.infinity,
            height: 48,
            margin: const EdgeInsets.all(14),
            child: FilledButton(
                style:
                    FilledButton.styleFrom(backgroundColor: AppColors.mainBlue),
                onPressed: () {},
                child: Text('다음')),
          ),
        ),
      ),
    );
  }
}
