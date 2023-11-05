import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/chat_room/f_chat_room.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:go_router/go_router.dart';

import '../vo_server_url.dart';

class CheckedModal extends ConsumerStatefulWidget {
  const CheckedModal({super.key});

  @override
  ConsumerState<CheckedModal> createState() => _CheckedModalState();
}

class _CheckedModalState extends ConsumerState<CheckedModal> {
  Future<void> PostCreatePromiseRoom(Promise promise) async {
    try {
      Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      String url = "$server/api/promise/room";
      var data = {
        "users": [
          {"nickname": "김태환", "userId": "1"},
          {"nickname": "정수완", "userId": "2"},
          {"nickname": "김현빈", "userId": "3"},
          {"nickname": "이상훈", "userId": "4"},
          {"nickname": "구희영", "userId": "5"},
          {"nickname": "김나연", "userId": "6"},
        ],
        "promiseTitle":
        promise.promise_title ?? "미정",
        "promiseDate": promise.promise_date != null
            ? promise.promise_date.toString()
            : "미정",
        "promiseTime": promise.promise_time != null
            ? promise.promise_time.toString()
            : "미정",
        "promiseLocation":
        promise.promise_location ?? "미정"
      };
      var response = await dio.post(url, data: data);
      print(response);
      print(response.data['result'][0]['id']);

      String room_id = response.data['result'][0]['id'];
      final router = GoRouter.of(context);
      // Nav.removeUntil((route) => false);
      router.go('/chatroom/$room_id');


    } catch (e) {
    print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final promise = ref.watch(promiseProvider);
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
                    topRight: Radius.circular(20)
                  )
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Text(
                        promise.promise_title != null ? '${promise.promise_title} 약속' : '약속 정하기',
                        style: const TextStyle(fontSize: 20, fontFamily: 'Pretendard', color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Container()),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.white, size: 24),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    MText(text: '제목 : ${promise.promise_title ?? '미정'}',18),
                    MText(
                        text:'날짜 : ${promise.promise_date ?? '미정'}', 18),
                    MText(
                        text:'시간 : ${promise.promise_time ?? '미정'}',18),
                    MText(
                        text:'장소 : ${promise
                            .promise_location ?? '미정'}', 18),
                    MText(18, text:
                    '총 N명'),
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
                                  backgroundColor: MaterialStateProperty.all(AppColors.grey300)
                              ),
                              child: const Text('취소', style: TextStyle(fontFamily: 'Pretendard', color: Colors.white))),
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
                                  backgroundColor: MaterialStateProperty.all(AppColors.mainBlue2)
                              ),
                              child: const Text('확인', style: TextStyle(fontFamily: 'Pretendard', color: Colors.white))),
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
}

class MText extends StatelessWidget {
  String text;
  double size;

  MText(this.size, {super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontFamily: 'Pretendard',
      fontSize: size,
      color: Colors.black
    ),);
  }
}

