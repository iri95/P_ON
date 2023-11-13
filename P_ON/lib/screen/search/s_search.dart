import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';

import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';

import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/user/user_state.dart';

import 'package:p_on/screen/search/w_search_bar.dart';
import 'package:p_on/screen/search/w_search_history_list.dart';
import 'package:p_on/screen/search/search_data.dart';

import 'package:get/get.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  late final searchData = Get.find<SearchData>();

  // 유저 검색
  Future<void> _searchUser(keyword) async {
    _controller.text = keyword;
    if (isBlank(keyword)) {
      searchData.isSearchEmpty.value = true;
      searchData.searchResult.clear();
      return;
    }

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
    try {
      var response = await apiService.sendRequest(
          method: 'GET', path: '/api/user/search/$keyword', headers: headers);
      // print(response.data['result']);

      // SearchUser 객체로 변환
      searchData.searchResult.value = (response.data['result'] as List<dynamic>)
          .map((item) => SearchUser.fromJson(item))
          .toList();
      searchData.isSearchEmpty.value = false;
      print(searchData.searchResult[0].relation);

      // TODO: 만약에 검색이 없다면, 검색된거 없음 띄워줘
    } catch (e) {
      print(e);
    }
  }

  Future<void> submitFollow(SearchUser element) async {
    var _relation = element.relation;
    var _id = element.id;

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
    final _method = _relation == 'FOLLOWING' ? 'DELETE' : 'POST';

    if (_relation == 'FOLLOWING') {
      searchData.updateRelation(element.id, 'NON');
    } else {
      searchData.updateRelation(element.id, 'FOLLOWING');
    }

    try {
      await apiService.sendRequest(
          method: _method,
          path: '/api/follow/following/$_id',
          headers: headers);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // 만약 GetX에 등록되어 있지 않다면
    if (!Get.isRegistered<SearchData>()) {
      // SearchData 타입의 새 인스턴스를 생성하고,
      // 이를 GetX의 의존성 관리 컨테이너에 등록
      Get.put(SearchData());
      // Get.find<SearchData>()를 통해 어디서든 이 인스턴스에 접근
    }
    searchData.isSearchEmpty.value = true;

    // input이 생길때마다 검색
    _controller.addListener(() {
      _searchUser(_controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    searchData.searchResult.clear();
    // Get.dispose<SearchData>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchBarWidget(controller: _controller),
        body: Obx(() => searchData.isSearchEmpty.value
            ? ListView(
                children: [
                  SearchHistoryList(
                    searchUser: _searchUser,
                  )
                ],
              )
            : ListView.builder(
                itemCount: searchData.searchResult.length,
                itemBuilder: (BuildContext context, int index) {
                  final element = searchData.searchResult[index];
                  return Tap(
                      onTap: () {
                        // TODO: 눌렀을 떄 그사람 프로필로 이동 또는 보이게?
                        // _controller.clear();
                      },
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.1))),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.network(
                                  element.profileImage,
                                  width: 56, // 2*radius
                                  height: 56, // 2*radius
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    // 에러 시 기본이미지
                                    return const Icon(Icons.account_circle,
                                        size: 56, color: Colors.grey);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    element.nickName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Pretendard'),
                                  )),
                              Expanded(child: Container()),
                              element.id.toString() !=
                                      ref.read(loginStateProvider).id.toString()
                                  ? FilledButton(
                                      style: FilledButton.styleFrom(
                                          minimumSize: const Size(75, 36),
                                          backgroundColor:
                                              element.relation == 'FOLLOWING'
                                                  ? AppColors.grey500
                                                  : AppColors.mainBlue),
                                      onPressed: () {
                                        submitFollow(element);
                                      },
                                      child: Text(
                                        element.relation == 'FOLLOWING'
                                            ? '팔로잉'
                                            : '팔로우',
                                        style: const TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ))
                                  : Container()
                            ],
                          )));
                },
              )));
  }
}
