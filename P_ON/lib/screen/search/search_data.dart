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

  SearchUser(
      {required this.id,
      required this.profileImage,
      required this.nickName,
      required this.privacy,
      this.stateMessage});

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
      id: json['id'],
      profileImage: json['profileImage'],
      nickName: json['nickName'],
      privacy: json['privacy'],
      stateMessage: json['stateMessage'],
    );
  }
}

class SearchData extends GetxController {
  List<SearchUser> searchUsers = [];
  RxList<String> searchHistoryList = <String>[].obs;
  RxList<SearchUser> searchResult = <SearchUser>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void addSearchHistory(String text) {
    searchHistoryList.insert(0, text);
  }
}
