import 'package:p_on/screen/main/tab/home/w_p_on_app_bar.dart';

import 'package:go_router/go_router.dart';
import 'package:p_on/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/tab/register/f_register.dart';

import 'dart:collection';
import 'package:dio/dio.dart';

import 'package:p_on/screen/main/tab/all/w_profile.dart';
import 'package:p_on/screen/main/tab/all/w_setting.dart';

import 'package:get/get.dart';
import 'package:p_on/screen/main/user/user_state.dart';

import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import './friend_provider.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/screen/main/s_main.dart';
import 'package:p_on/screen/main/tab/tab_item.dart';
import 'package:p_on/screen/main/tab/benefit/complete_provider.dart';

// Future<void> fetchFollow() async {
final fetchFollowProvider = FutureProvider.autoDispose<void>((ref) async {
  final loginState = ref.read(loginStateProvider);
  final token = loginState.serverToken;
  final id = loginState.id;

  var headers = {'Authorization': '$token', 'id': '$id'};

  final apiService = ApiService();

  // 팔로잉
  try {
    var response = await apiService.sendRequest(
        method: 'GET', path: '/api/follow/following', headers: headers);

    ref.read(followingCountProvider.notifier).state = response.data['count'];
    var data = response.data['result'] as List;
    List<Friends> followingList =
        await data.map((item) => Friends.fromJson(item)).toList();
    ref.read(followingListProvider.notifier).setFollowingList(followingList);
  } catch (e) {
    print(e);
  }

  // 팔로워
  try {
    var response = await apiService.sendRequest(
        method: 'GET', path: '/api/follow/follower', headers: headers);

    ref.read(followerCountProvider.notifier).state = response.data['count'];
    var data = response.data['result'] as List;
    List<Friends> followerList =
        await data.map((item) => Friends.fromJson(item)).toList();
    ref.read(followerListProvider.notifier).setFollowerList(followerList);
  } catch (e) {
    print(e);
  }
});

class AllFragment extends ConsumerStatefulWidget {
  const AllFragment({Key? key}) : super(key: key);

  @override
  ConsumerState<AllFragment> createState() => _AllFragmentState();
}

class _AllFragmentState extends ConsumerState<AllFragment> {
  @override
  Widget build(BuildContext context) {
    ref.listen(currentTabProvider, (_, TabItem? newTabItem) async {
      print('===========================================================');
      print(newTabItem);
      // currentTabProvider의 상태가 변경될 때마다 이 부분이 호출됩니다.
      // 마이페이지 일때
      if (newTabItem == TabItem.my) {
        // print(ref.read(userStateProvider)?.nickName);
        ref.read(fetchFollowProvider.future);
      }
    });

    return Material(
        child: Column(children: [
      const PONAppBar(),
      Expanded(
        child: Container(
          color: Color(0xffe4e8ef),
          child: ListView(
            children: const [
              Profile(),
              height10,
              Setting(),
            ],
          ),
        ),
      )
    ]));
  }
}
