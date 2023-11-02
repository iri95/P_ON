import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/tab/chat_room/f_chat_room.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';

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
            promise.promise_title != null ? promise.promise_title : "미정",
        "promiseDate": promise.promise_date != null
            ? promise.promise_date.toString()
            : "미정",
        "promiseTime": promise.promise_time != null
            ? promise.promise_time.toString()
            : "미정",
        "promiseLocation":
            promise.promise_location != null ? promise.promise_location : "미정"
      };
      var response = await dio.post(url, data: data);

      String room_id = response.data['result'][0]['id'];
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => ChatRoom(id: room_id)), (route) => false);
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
      title: const Text('약속 정하기', style: TextStyle(fontSize: 16)),
      content: Container(
        height: 200,
        child: Column(
          children: [
            const Expanded(child: Text('')),
            Text(
                '제목 : ${promise.promise_title != null ? promise.promise_title : '미정'}'),
            Text(
                '날짜 : ${promise.promise_date != null ? promise.promise_date : '미정'}'),
            Text(
                '시간 : ${promise.promise_time != null ? promise.promise_time : '미정'}'),
            Text(
                '장소 : ${promise.promise_location != null ? promise.promise_location : '미정'}'),
            Text('멤버 : ${promise.selected_friends}'),
            const Expanded(child: Text('')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () async {
                      await PostCreatePromiseRoom(promise);
                    },
                    child: Text('확인')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('취소')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
