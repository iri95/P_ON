import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';

import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';

import 'package:p_on/common/common.dart';

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

  int _searchCount = 0;

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

      _searchCount = response.data['count'];

      // SearchUser 객체로 변환
      searchData.searchResult.value = (response.data['result'] as List<dynamic>)
          .map((item) => SearchUser.fromJson(item))
          .toList();
      searchData.isSearchEmpty.value = false;

      // TODO: 만약에 검색이 없다면, 검색된거 없음 띄워줘야함
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    searchData.isSearchEmpty.value = true;
    // 만약 GetX에 등록되어 있지 않다면
    if (!Get.isRegistered<SearchData>()) {
      // SearchData 타입의 새 인스턴스를 생성하고,
      // 이를 GetX의 의존성 관리 컨테이너에 등록
      Get.put(SearchData());
      // Get.find<SearchData>()를 통해 어디서든 이 인스턴스에 접근
    }
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
                // TODO: 맨 위에 검색 결과 갯수 보여주기 ${searchCount}
                itemBuilder: (BuildContext context, int index) {
                  final element = searchData.searchResult[index];
                  return Tap(
                    onTap: () {
                      // TODO: 눌렀을 떄 그사람 프로필로 이동 또는 보이게?
                      _controller.clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: element.nickName.text.make(),
                    ),
                  );
                },
              )));
  }
}
