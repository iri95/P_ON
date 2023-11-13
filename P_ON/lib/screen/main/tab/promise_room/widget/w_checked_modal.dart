import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:p_on/screen/main/tab/chat_room/f_chat_room.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:go_router/go_router.dart';
import 'package:p_on/screen/main/user/token_state.dart';
import '../../../user/fn_kakao.dart';
import '../vo_server_url.dart';

class CheckedModal extends ConsumerStatefulWidget {
  const CheckedModal({super.key});

  @override
  ConsumerState<CheckedModal> createState() => _CheckedModalState();
}

class _CheckedModalState extends ConsumerState<CheckedModal> {
  @override
  Widget build(BuildContext context) {
    final promise = ref.watch(promiseProvider);
    print(promise.promise_date);
    print(promise.promise_time);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: const BoxDecoration(
                    color: AppColors.mainBlue2,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 24),
                      child: const Text(
                        '약속 생성',
                        // promise.promise_title != null
                        //     ? '${promise.promise_title}'
                        //     : '약속 정하기',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Container()),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 24),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                width: 300,
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 20.0, top: 16),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(0.5), // 첫 번째 열은 가변적인 너비를 가지도록 설정
                          },
                          children: [
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text('제목'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                        '${promise.promise_title ?? '미정'}'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text('날짜'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                        '${promise.promise_date != null ? DateFormat('yyyy-MM-dd (E)', 'ko_kr').format(promise.promise_date!) : '미정'}'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text('시간'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child:
                                        Text('${promise.promise_time ?? '미정'}'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text('장소'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                        '${promise.promise_location ?? '미정'}'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text('친구'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                        '${promise.selected_friends?[0].nickName} 외 ${promise.selected_friends?.length} 명'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    const Expanded(child: Text('')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 40,
                          margin: const EdgeInsets.only(right: 6, bottom: 12),
                          child: FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColors.grey300)),
                              child: const Text('취소',
                                  style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      color: Colors.white))),
                        ),
                        Container(
                          height: 40,
                          width: 80,
                          margin: const EdgeInsets.only(left: 6, bottom: 12),
                          child: FilledButton(
                              onPressed: () async {
                                await PostCreatePromiseRoom(promise);
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColors.mainBlue2)),
                              child: const Text('확인',
                                  style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      color: Colors.white))),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> PostCreatePromiseRoom(Promise promise) async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;
    var headers = {'Authorization': '$token', 'id': '$id'};
    final apiService = ApiService();

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

    var users = promise.selected_friends?.map((friend) => friend.id).toList();

    var data = {
      "users": users,
      "promiseTitle": promise.promise_title ?? "미정",
      "promiseDate":
          promise.promise_date != null ? promise.promise_date.toString() : "미정",
      "promiseTime": promise.promise_time ?? "미정",
      "promiseLocation": promise.promise_location ?? "미정"
    };

    try {
      // method: '대문자', path: 'end-point', headers:headers고정, data: {POST data 있을 때 key:valure}'
      Response response = await apiService.sendRequest(
          method: 'POST',
          path: '$server/api/promise/room',
          headers: headers,
          data: data);

      print(response);
      int room_id = response.data['result'][0]['id'];

      final router = GoRouter.of(context);
      router.go('/chatroom/$room_id');

      // ref.read(promiseProvider.notifier).reset();
    } catch (e) {
      print(e);
    }
  }
}

class MText extends StatelessWidget {
  String text;
  double size;

  MText(this.size, {super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Pretendard', fontSize: size, color: Colors.black),
    );
  }
}
