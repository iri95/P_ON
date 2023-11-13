import 'package:get/get.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:p_on/screen/main/tab/promise_room/f_last_create_promise.dart';
import 'package:p_on/screen/main/tab/promise_room/widget/w_follows.dart';
import 'package:p_on/screen/main/tab/promise_room/widget/w_friends_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SelectedFriends extends ConsumerStatefulWidget {
  const SelectedFriends({super.key});

  @override
  ConsumerState<SelectedFriends> createState() => _SelectedFriendsState();
}

class _SelectedFriendsState extends ConsumerState<SelectedFriends> {
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    final promise = ref.watch(promiseProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Nav.pop(context);
          },
        ),
        title: '약속 생성'.text.bold.black.make(),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            percent: 66 / 100,
            lineHeight: 5,
            backgroundColor: const Color(0xffCACFD8),
            progressColor: AppColors.mainBlue3,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            alignment: Alignment.topLeft,
            child: '약속을 함께 할 친구를 추가해주세요'.text.black.size(18).semiBold.make(),
          ),
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      children: promise.selected_friends
                              ?.map((friend) => FriendsList(friend))
                              .toList() ??
                          []),
                ),
              ],
            ),
          ),

          // TODO: 이거 어쩔까
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          // Expanded(
          //   child: Container(
          //     height: 62,
          //     margin: const EdgeInsets.only(left: 32, right: 16),
          //     decoration: BoxDecoration(
          //         color: AppColors.grey200,
          //         borderRadius: BorderRadius.circular(10)),
          //     child: TextButton(
          //         style: TextButton.styleFrom(primary: Colors.black),
          //         onPressed: () {},
          //         child: const Column(
          //           children: [Icon(Icons.link), Text('링크 복사')],
          //         )),
          //   ),
          // ),
          //   Expanded(
          //     child: Container(
          //       height: 62,
          //       margin: const EdgeInsets.only(left: 16, right: 32),
          //       decoration: BoxDecoration(
          //           color: AppColors.grey200,
          //           borderRadius: BorderRadius.circular(10)),
          //       child: TextButton(
          //           style: TextButton.styleFrom(primary: Colors.black),
          //           onPressed: () {},
          //           child: const Column(
          //             children: [Icon(Icons.search), Text('닉네임 검색')],
          //           )),
          //     ),
          //   ),
          // ],
          // ),
          const Expanded(child: Follows()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          width: double.infinity,
          height: 48,
          margin: const EdgeInsets.all(14),
          child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: promise.selected_friends?.length != 0
                      ? AppColors.mainBlue
                      : Colors.grey),
              onPressed: () {
                if (promise.selected_friends == null ||
                    promise.selected_friends!.length == 0) {
                  setState(() {
                    _showError = true;
                  });
                } else {
                  Nav.push(const LastCreatePromise());
                }
              },
              child: const Text('다음'))),
    );
    // ,
    //   ),
    // );
  }
}
