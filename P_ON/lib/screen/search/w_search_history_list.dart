import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/search/search_data.dart';

import 'package:p_on/screen/search/w_history_item.dart';

class SearchHistoryList extends StatefulWidget {
  final Function(String) searchUser;
  final Function(String) searchHistory;

  const SearchHistoryList(
      {Key? key, required this.searchUser, required this.searchHistory})
      : super(key: key);

  @override
  State<SearchHistoryList> createState() => _SearchHistoryListState();
}

class _SearchHistoryListState extends State<SearchHistoryList> {
  final searchData = Get.find<SearchData>();

  // final _searchHistoryData = Get.find<SearchData>();

  // get historyList => _searchHistoryData.searchHistoryList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: ["최근 검색".text.bold.make()],
        ).pSymmetric(h: 16, v: 10),
        // SizedBox(height: 10),
        // TODO:  이거 CSS
        Obx(() => Column(
            children: searchData.searchHistoryList
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey, // 테두리 색상 설정
                              width: 0.3, // 테두리 두께 설정
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: GestureDetector(
                            onTap: () {
                              widget.searchUser(item);
                              widget.searchHistory(item);
                            },
                            child: Text(item),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              searchData.removeSearchHistory(item);
                            },
                          ),
                        ),
                      ),
                    ))
                .toList())),
      ],
    );
  }
}
