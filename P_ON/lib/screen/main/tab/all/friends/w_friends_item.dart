import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:flutter/material.dart';
import '../friend_provider.dart';
import '../f_all.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';

import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/user/user_state.dart';

class FriendsItem extends ConsumerWidget {
  // true: following, false: follower
  final bool isSelected;
  final Friends friend;

  const FriendsItem(this.friend, {super.key, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isFollow;

    Future<void> submitFollow(friend) async {
      print(friend);
      print(friend.followBack);

      final loginState = ref.read(loginStateProvider);
      final token = loginState.serverToken;
      final id = loginState.id;

      var headers = {'Authorization': '$token', 'id': '$id'};

      // 서버 토큰이 없으면
      if (token == null) {
        await kakaoLogin(ref);
        await fetchToken(ref);

        final newToken = ref.read(loginStateProvider).serverToken;
        final newId = ref.read(loginStateProvider).id;

        headers['Authorization'] = '$newToken';
        headers['id'] = '$newId';
      }

      final apiService = ApiService();

      final _method = isSelected
          ? 'DELETE'
          : friend.followBack == true
              ? 'DELETE'
              : 'POST';

      try {
        await apiService.sendRequest(
            method: _method,
            path: '/api/follow/following/${friend.id}',
            headers: headers);

        // 팔로우 / 팔로잉 다시 조회
        ref.refresh(fetchFollowProvider);
      } catch (e) {
        print(e);
      }
    }

    final followingCount = ref.watch(followingCountProvider);
    final followingList = ref.watch(followingListProvider);
    final followerCount = ref.watch(followerCountProvider);
    final followerList = ref.watch(followerListProvider);

    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              friend.profileImage,
              width: 56, // 2*radius
              height: 56, // 2*radius
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                // 에러 시 기본이미지
                return const Icon(Icons.account_circle,
                    size: 56, color: Colors.grey);
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                friend.nickName,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard'),
              )),
          Expanded(child: Container()),
          FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: const Size(75, 36),
                  backgroundColor:
                      // 팔로우백이 true이면 맞팔
                      isSelected
                          ? AppColors.grey500
                          : friend.followBack
                              ? AppColors.grey500
                              : AppColors.mainBlue),
              onPressed: () async {
                await submitFollow(friend);

                // // FIXME: 이게맞나
                // ref.refresh(fetchFollowProvider);
              },

              // 이 탭이 following이면 isSelected true? 항상 true
              // 팔로우이면, followback이
              // isSelected ? 'DELETE' : friend.followBack == true ? 'DELETE' : 'POST';
              child: Text(
                isSelected
                    ? '팔로잉'
                    : friend.followBack
                        ? '팔로잉'
                        : '팔로우',
                style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ))
        ],
      ),
    );
  }
}
