import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/widget/w_list_container.dart';
import 'package:flutter/material.dart';
import 'package:p_on/screen/main/tab/benefit/complete_provider.dart';
import 'package:p_on/screen/main/tab/chat_room/dto_vote.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_server_url.dart';

import 'f_home.dart';
import 'w_custom_text.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import 'package:p_on/screen/main/s_main.dart';
import 'package:p_on/screen/main/tab/tab_item.dart';

class MyPlanAndPromise extends ConsumerStatefulWidget {
  const MyPlanAndPromise({super.key});

  @override
  ConsumerState<MyPlanAndPromise> createState() => _MyPlanAndPromiseState();
}

class _MyPlanAndPromiseState extends ConsumerState<MyPlanAndPromise> {
  bool isClose = false;
  List<dynamic> promise = [];
  var promiseCount = 1;
  final currentDate = DateTime.now();

  Future<void> getPromiseRoom() async {
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
          method: 'GET', path: '$server/api/promise/room', headers: headers);
      // print(response.data['result'][0]);
      print('1getPromiseRoom');
      print(response);
      promise = await response.data['result'][0];
      promiseCount = response.data['count'];
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    print('w_myPlan');
    getPromiseRoom();
    super.initState();
  }

  String changeDate(String date) {
    DateTime chatRoomDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatterDate = formatter.format(chatRoomDate);
    return formatterDate;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(completeProvider, (_, CompleteData? newComplete) async {
      await getPromiseRoom();
    });

    ref.listen(currentTabProvider, (_, TabItem? newTabItem) async {
      if (newTabItem == TabItem.home) {
        await getPromiseRoom();
      }
    });

    Future.microtask(() => ref.read(promiseProvider.notifier).reset());

    // 화면 비율
    final Size size = MediaQuery.of(context).size;
    // if (promise.length == 0) {
    if (promiseCount == 0) {
      return Container(
        width: double.infinity,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/main/login.png',
              width: MediaQuery.of(context).size.width - 150,
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: const Text('아직 만들어진 약속이 없어요!',
                  style: TextStyle(
                      color: AppColors.mainBlue2,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard')),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '핑키',
                  style: TextStyle(
                    color: AppColors.pointOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                  ),
                ),
                Text(
                  '와 약속을 만들어 봐요',
                  style: TextStyle(
                    color: AppColors.mainBlue2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: promise.length,
          itemBuilder: (context, index) {
            var item = promise[index];

            // isClose 계산부분
            if (item['promiseDate'] != '미정') {
              var promiseDateString = item['promiseDate'];
              DateTime promiseDate;

              if (promiseDateString.length == 10) {
                promiseDateString += ' 00:00:00.000';
              }

              promiseDate = DateTime.parse(promiseDateString);

              var diffDate = promiseDate.difference(currentDate);

              if (!diffDate.isNegative && diffDate.inDays < 3) {
                isClose = true;
              } else {
                isClose = false;
              }
            }

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
                final router = GoRouter.of(context);
                router.push('/chatroom/${item['id']}');
              },
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: size.width * 0.9,
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
                                      color: isClose
                                          ? AppColors.grey50
                                          : Colors.black)),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 8),
                              height: 30,
                              child: Row(children: [
                                CustomText(
                                  text: '일시 | ',
                                  color: isClose
                                      ? AppColors.grey300
                                      : AppColors.grey500,
                                  fontWeightValue: FontWeight.w400,
                                ),
                                item['promiseDate'] == '미정'
                                    ? const CreateVote()
                                    : CustomText(
                                        text: changeDate(item['promiseDate']),
                                        color: isClose
                                            ? AppColors.grey50
                                            : AppColors.grey700,
                                        fontWeightValue: FontWeight.w500,
                                      ),
                              ]),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 8),
                              height: 30,
                              child: Row(
                                children: [
                                  CustomText(
                                    text: '시간 | ',
                                    color: isClose
                                        ? AppColors.grey300
                                        : AppColors.grey500,
                                    fontWeightValue: FontWeight.w400,
                                  ),
                                  item['promiseTime'] == '미정'
                                      ? const CreateVote()
                                      : CustomText(
                                          text: item['promiseTime'],
                                          color: isClose
                                              ? AppColors.grey50
                                              : AppColors.grey700,
                                          fontWeightValue: FontWeight.w500,
                                        ),
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomText(
                                        text: '장소 | ',
                                        color: isClose
                                            ? AppColors.grey300
                                            : AppColors.grey500,
                                        fontWeightValue: FontWeight.w400,
                                      ),
                                      item['promiseLocation'] == '미정'
                                          ? const CreateVote()
                                          : CustomText(
                                              text: item['promiseLocation']
                                                          .length >
                                                      12
                                                  ? '${item['promiseLocation'].substring(0, 12)}...'
                                                  : item['promiseLocation'],
                                              color: isClose
                                                  ? AppColors.grey50
                                                  : AppColors.grey700,
                                              fontWeightValue: FontWeight.w500,
                                            ),
                                    ],
                                  ),
                                  // 채팅방
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                          radius: 15,
                                          backgroundColor:
                                              const Color(0xffEFF3F9),
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..scale(-1.0, 1.0),
                                            child: Icon(
                                              Icons.chat_bubble,
                                              size: 15,
                                              color: isClose
                                                  ? Color(0xffFFBA20)
                                                  : Color(0xffef8640),
                                            ),
                                          )),
                                      if (item['read'])
                                        const Positioned(
                                            right: 5,
                                            top: 5,
                                            child: CircleAvatar(
                                              radius: 4,
                                              backgroundColor: Colors.red,
                                            ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Pinky 아이콘
                  Positioned(
                      right: size.width * 0.08,
                      child: Image(
                        image: isClose
                            ? const AssetImage('assets/image/main/핑키3.png')
                            : const AssetImage('assets/image/main/핑키2.png'),
                        fit: BoxFit.contain,
                        width: 60,
                      )),
                ],
              ),
            );
            // 받아온 데이터에 미정 포함되면 투표생성 버튼 보여주기
          });
    }
  }
}

class CreateVote extends StatelessWidget {
  const CreateVote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      width: 80,
      height: 25,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(const Color(0xFFFF7F27)),
        ),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '투표',
              style: TextStyle(
                  color: Color(0xFFFF7F27),
                  fontSize: 14,
                  fontWeight: FontWeight.w800),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFF7F27))
          ],
        ),
      ),
    );
  }
}
