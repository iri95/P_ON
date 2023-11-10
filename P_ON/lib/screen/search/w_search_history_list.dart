import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/search/search_data.dart';

import 'package:p_on/screen/search/w_history_item.dart';

class SearchHistoryList extends StatefulWidget {
  const SearchHistoryList({Key? key}) : super(key: key);

  @override
  State<SearchHistoryList> createState() => _SearchHistoryListState();
}

class _SearchHistoryListState extends State<SearchHistoryList> {
  late final _searchHistoryData = Get.find<SearchData>();

  get historyList => _searchHistoryData.searchHistoryList;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: ["최근 검색".text.bold.make()],
      ).pSymmetric(h: 16, v: 20),
      // SizedBox(height: 10),
      height20,
      ...historyList.map((item) => Text(item)).toList(),
      // Expanded(
      //     child: ListView(
      //   children: [
      //     Row(
      //       children: [Text('ㅇㅇ')],
      //     )
      //   ],
      //   // itemBuilder: (context, index) => Text(historyList[index]),
      // ))
      // Expanded(
      //   child: ListView.builder(
      //     itemCount: historyList.length,
      //     itemBuilder: (context, index) => Text(historyList[index]),
      //     // itemBuilder: (context, index) => SearchHistoryItem(
      //     //       onTapDelete: () {
      //     //         setState(() {
      //     //           historyList.removeAt(index);
      //     //         });
      //     //       },
      //     //       text: historyList[index],
      //     //     )
      //   ),
      // )
    ]);
  }
}
