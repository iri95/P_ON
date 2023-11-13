import 'package:p_on/common/common.dart';
import 'package:p_on/common/util/app_keyboard_util.dart';
import 'package:p_on/common/widget/w_text_field_with_delete.dart';
import 'package:flutter/material.dart';
import 'package:p_on/screen/search/search_data.dart';
import 'package:get/get.dart';

class SearchBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;

  SearchBarWidget({required this.controller, Key? key}) : super(key: key);

  final searchData = Get.find<SearchData>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 뒤로가기
            Tap(
              onTap: () {
                Nav.pop(context);
              },
              child: SizedBox(
                height: 50,
                width: 50,
                child: const Icon(Icons.arrow_back_ios, color: Colors.black)
                    .pOnly(left: 15),
              ),
            ),

            // 검색창
            Expanded(
              child: TextFieldWithDelete(
                deleteIconColor: Colors.black,
                deleteRightPadding: 8,
                textInputAction: TextInputAction.search,
                controller: controller,
                texthint: "닉네임 검색",
                focusedBorder: Colors.transparent,
                fontSize: 18,
                onEditingComplete: () {
                  //search
                  searchData.addSearchHistory(controller.text);
                  AppKeyboardUtil.hide(context);
                },
              ).pOnly(top: 5),
            ),

            // 검색 아이콘
            Tap(
                onTap: () {
                  //search
                  searchData.addSearchHistory(controller.text);
                  AppKeyboardUtil.hide(context);
                },
                child: SizedBox(
                    height: 50,
                    width: 50,
                    // FIXME: 바깥 아이콘이랑 같은걸로 수정
                    child: const Icon(Icons.search).pOnly(right: 15)))
          ],
        ),
      ),
    ));
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}
