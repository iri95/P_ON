import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:p_on/common/common.dart';

class SearchUser {
  final int id;
  final String profileImage;
  final String nickName;
  final String privacy;
  final String? stateMessage;
  String relation;

  SearchUser({
    required this.id,
    required this.profileImage,
    required this.nickName,
    required this.privacy,
    this.stateMessage,
    required this.relation,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
        id: json['id'],
        profileImage: json['profileImage'],
        nickName: json['nickName'],
        privacy: json['privacy'],
        stateMessage: json['stateMessage'],
        relation: json['relation']);
  }
}

class SearchData extends GetxController {
  List<SearchUser> searchUsers = [];
  RxList<String> searchHistoryList = <String>[].obs;
  RxList<SearchUser> searchResult = <SearchUser>[].obs;
  RxBool isSearchEmpty = true.obs;

  @override
  void onInit() {
    // searchHistoryList.addAll(['검색1', '검색1']);
    super.onInit();
  }

  void removeSearchHistory(String text) {
    searchHistoryList.remove(text);
  }

  void addSearchHistory(String text) {
    // text가 빈 문자열인지 확인
    if (text.trim().isEmpty) {
      return; // 빈 문자열이면 메서드를 종료
    }
    if (searchHistoryList.contains(text)) {
      searchHistoryList.remove(text);
    }
    searchHistoryList.insert(0, text);
  }

  void updateRelation(int userId, String newRelation) {
    int index = searchResult.indexWhere((user) => user.id == userId);
    if (index != -1) {
      searchResult[index].relation = newRelation;
      searchResult.refresh();
      print(searchResult[index].relation);
    }
  }
}
