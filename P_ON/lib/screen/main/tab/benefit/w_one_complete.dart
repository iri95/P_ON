import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/widget/w_list_container.dart';
import 'package:flutter/material.dart';

import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';

import 'package:p_on/screen/main/user/token_state.dart';

import 'package:p_on/screen/main/tab/home/w_custom_text.dart';

import 'complete_provider.dart';

class OneCompletePromise extends ConsumerStatefulWidget {
  final dynamic item;
  final Size size;
  const OneCompletePromise({Key? key, required this.item, required this.size})
      : super(key: key);

  @override
  ConsumerState<OneCompletePromise> createState() => _OneCompletePromiseState();
}

class _OneCompletePromiseState extends ConsumerState<OneCompletePromise> {
  bool isClose = false;

  String changeDate(String date) {
    DateTime chatRoomDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatterDate = formatter.format(chatRoomDate);
    return formatterDate;
  }

  List<dynamic> users = [];

  // 하나 패칭
  Future<void> oneComplete(item) async {
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': '$id'};

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
          method: 'GET',
          path: '/api/promise/room/${item['id']}',
          headers: headers);

      users = response.data['result'][0]['users'];
      print(users);
      // List<dynamic> newComplete = await response.data['result'][0];
      // int newCompleteCount = response.data['count'];
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    print(11);
    oneComplete(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    final completeData = ref.watch(completeProvider);
    dynamic item = widget.item;

    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.transparent; // 눌렀을 때 배경색 없음
            }
            return Colors.transparent; // 기본 배경색 없음
          },
        ),
      ),
      onPressed: () {
        // TODO: 추억 클릭 시 뭐나옴
        print('추억으로');
        // final router = GoRouter.of(context);
        // router.go('/chatroom/${item['id']}');
      },
      child: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: widget.size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(4, 4))
                  ]),
              child: ListContainer(
                padding: const EdgeInsets.fromLTRB(24, 16, 20, 16),
                isDateClose: isClose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 약속명
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                          item['promiseTitle'].length > 12
                              ? '${item['promiseTitle'].substring(0, 12)}...'
                              : item['promiseTitle'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color:
                                  isClose ? AppColors.grey50 : Colors.black)),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      height: 30,
                      child: Row(children: [
                        CustomText(
                          text: '일시 | ',
                          color:
                              isClose ? AppColors.grey300 : AppColors.grey500,
                          fontWeightValue: FontWeight.w400,
                        ),
                        CustomText(
                          text: changeDate(item['promiseDate']),
                          color: isClose ? AppColors.grey50 : AppColors.grey700,
                          fontWeightValue: FontWeight.w500,
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // 유저 이미지
                    Container(
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: users
                              .map((item) => Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 56,
                                          height: 56,
                                          child: ClipOval(
                                            child: Image.network(
                                              item['profileImage'],
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return const Icon(
                                                    Icons.account_circle,
                                                    size: 56,
                                                    color: Colors.grey);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        )),
                  ],
                ),
              ),
            ),
          ),

          // Pinky 아이콘
          Positioned(
              right: widget.size.width * 0.08,
              child: const Image(
                image: AssetImage('assets/image/main/핑키1.png'),
                fit: BoxFit.contain,
                width: 60,
              )),
        ],
      ),
    );
  }
}
