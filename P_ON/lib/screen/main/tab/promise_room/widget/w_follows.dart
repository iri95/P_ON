import 'package:p_on/common/constant/app_colors.dart';
import 'package:p_on/screen/main/tab/promise_room/widget/w_following_list.dart';
import 'package:flutter/material.dart';
import '../dto_promise.dart';
import '../vo_server_url.dart';
import 'w_followers_list.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';

class Follows extends ConsumerStatefulWidget {
  const Follows({super.key});

  @override
  ConsumerState<Follows> createState() => _FollowsState();
}

class _FollowsState extends ConsumerState<Follows> {
  bool isSelected = true;
  List followingList = [];
  List followerList = [];

  Future<void> getFollowingList() async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};

    // 서버 토큰이 없으면
    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);

      // 토큰을 다시 읽습니다.
      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;

      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'GET',
          path: '$server/api/follow/following',
          headers: headers);

      if (response.statusCode == 200) {
        var data = response.data['result'] as List;
        followingList =
            await data.map((item) => Friends.fromJson(item)).toList();
        print('팔로잉 목록조회');
        print(followingList);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getFollowerList() async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};

    // 서버 토큰이 없으면
    if (token == null) {
      await kakaoLogin(ref);
      await fetchToken(ref);

      // 토큰을 다시 읽습니다.
      final newToken = ref.read(loginStateProvider).serverToken;
      final newId = ref.read(loginStateProvider).id;

      headers['Authorization'] = '$newToken';
      headers['id'] = '$newId';
    }

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'GET', path: '$server/api/follow/follower', headers: headers);

      if (response.statusCode == 200) {
        var data = response.data['result'] as List;
        followerList =
            await data.map((item) => Friends.fromJson(item)).toList();
        print('팔로워 목록조회');
        print(followerList);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getFollowingList();
    getFollowerList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: isSelected ? Colors.blue : Colors.grey))),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black;
                    } else {
                      return Colors.grey;
                    }
                  }),
                ),
                child: Text('Followings ${followingList.length}명',
                    style: TextStyle(
                        fontSize: 20,
                        color: isSelected ? AppColors.mainBlue : Colors.black)),
              ),
            )),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: !isSelected ? Colors.blue : Colors.grey))),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black;
                    } else {
                      return Colors.grey;
                    }
                  }),
                ),
                child: Text('Followers ${followerList.length}명',
                    style: TextStyle(
                        fontSize: 20,
                        color:
                            !isSelected ? AppColors.mainBlue : Colors.black)),
              ),
            )),
          ],
        ),
        Expanded(
            child: isSelected
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 80),
                      child: Column(
                        children: [
                          ...followingList
                              .map((followings) => FollowingsList(followings))
                              .toList()
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 80),
                      child: Column(
                        children: [
                          ...followerList
                              .map((followers) => FollowersList(followers))
                              .toList()
                        ],
                      ),
                    ),
                  ))
      ],
    );
  }
}
