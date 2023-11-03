import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:p_on/common/constant/app_colors.dart';
import 'package:p_on/common/util/app_keyboard_util.dart';
import 'package:p_on/common/widget/w_basic_appbar.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_naver_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:nav/nav.dart';
import 'package:velocity_x/velocity_x.dart';

class LastCreatePromise extends StatefulWidget {
  const LastCreatePromise({super.key});

  @override
  State<LastCreatePromise> createState() => _LastCreatePromiseState();
}

class _LastCreatePromiseState extends State<LastCreatePromise>
    with AfterLayoutMixin {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  final FocusNode dateNode = FocusNode();
  final FocusNode timeNode = FocusNode();
  final FocusNode placeNode = FocusNode();

  bool get isFilled => dateController.text.isNotEmpty &&
      timeController.text.isNotEmpty &&
      placeController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    dateController.addListener(updateState);
    timeController.addListener(updateState);
    placeController.addListener(updateState);
    dateNode.addListener(updateState);
    timeNode.addListener(updateState);
    placeNode.addListener(updateState);
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return
      // MaterialApp(
      // debugShowCheckedModeBanner: false,
      // home: SafeArea(
      //   child:
        Scaffold(
          appBar: AppBar(
            title: '약속 생성'.text.bold.make(),
          ),
          body: Column(
            children: [
              // const BasicAppBar(
              //     text: '약속 생성', isProgressBar: true, percentage: 100),
              _buildTextField('날짜', dateController, dateNode, timeNode),
              _buildTextField('시간', timeController, timeNode, placeNode),
              _buildTextField('장소', placeController, placeNode, null),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            width: double.infinity,
            height: 48,
            margin: const EdgeInsets.all(14),
            child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                    backgroundColor: isFilled ? AppColors.mainBlue : Colors.grey),
                child: Text(isFilled ? '다음' : '건너뛰기')),
          ),
        );
    //   ,),
    // );
  }

  Widget _buildTextField(String label, TextEditingController controller, FocusNode node, FocusNode? nextNode) {
    final dio = Dio();
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          alignment: Alignment.topLeft,
          child: Text(label, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: controller.text.isEmpty && !node.hasFocus
                  ? Colors.grey
                  : AppColors.mainBlue2,
            ),
          ),
          child: TextField(
            focusNode: node,
            controller: controller,
            decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
            onSubmitted: (text) async {
              node.unfocus();
              if (nextNode != null) {
                FocusScope.of(context).requestFocus(nextNode);
              }
              if(label == '장소' && text.isNotEmpty) {
                SearchPlace(text);
              }
            },
          ),
        ),
      ],
    );
  }

  void SearchPlace(String text) async {
    final dio = Dio();
    final response = await dio.get(
      'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode',
      queryParameters: {
        'query': text,
      },
      options: Options(
        headers: {
          'X-NCP-APIGW-API-KEY-ID': Client_ID,
          'X-NCP-APIGW-API-KEY': Client_Secret,
        },
      ),
    );
    if (response.statusCode == 200) {
      print(response.data);
    } else {
      print(response.data.errorMessage);
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    AppKeyboardUtil.show(context, dateNode);
  }
}
