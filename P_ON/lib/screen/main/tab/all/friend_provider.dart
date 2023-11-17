import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';

class FollowingListNotifier extends StateNotifier<List<Friends>> {
  FollowingListNotifier() : super([]);

  void setFollowingList(List<Friends> list) {
    state = list;
  }
}

final followingListProvider =
    StateNotifierProvider<FollowingListNotifier, List<Friends>>(
        (ref) => FollowingListNotifier());

final followingCountProvider = StateProvider<int>((ref) => 0);

class FollowerListNotifier extends StateNotifier<List<Friends>> {
  FollowerListNotifier() : super([]);

  void setFollowerList(List<Friends> list) {
    state = list;
  }
}

final followerListProvider =
    StateNotifierProvider<FollowerListNotifier, List<Friends>>(
        (ref) => FollowerListNotifier());

final followerCountProvider = StateProvider<int>((ref) => 0);
