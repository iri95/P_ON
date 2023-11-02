import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/widget/w_basic_appbar.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';
import '../promise_room/vo_server_url.dart';


class ChatRoom extends ConsumerStatefulWidget {
  final String id;
  const ChatRoom({super.key, required this.id});
  @override
  ConsumerState<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {
  final FocusNode node = FocusNode();
  final TextEditingController textController = TextEditingController();

  final Dio dio = Dio();
  late StompClient client;
  final String userId = "2";
  final String userName = "정수완";
  List<Map<String, dynamic>> messages = [];


  void onConnect(StompFrame? frame) {
    client.subscribe(
        destination: '/topic/chat/${widget.id}',
        callback: (frame) {
          if (frame.body != null) {
            Map<String, dynamic>? result = json.decode(frame.body!);
            print(result!['body']['result']);
            print(result!['body']['result'][0]['sender']);
            print(result!['body']['result'][0]['senderId']);
            print(result!['body']['result'][0]['content']);
            print(result!['body']['result'][0]['createAt']);
          } else {
            print('바디가 비었다 이말이야');
          }
        }
    );
  }

  void sendChat(String roomId, String userId, String nickname, String content) {
    String destination = '/app/api/promise/chat/$roomId/$userId';
    Map<String, dynamic> message = {
      'sender' : nickname,
      'chatType' : 'TEXT',
      'content' : content
    };

    client.send(
      destination: destination,
      body: jsonEncode(message),
    );
    print('보내짐');
    print(destination);
    print(message);
  }

  late final String formatedDate =
      DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(DateTime.now());

  @override
  void initState() {
    super.initState();

    client = StompClient(
      config: StompConfig.sockJS(
        url: '$server/api/promise/ws-stomp',
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error)
      )
    );

    client.activate();
    node.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const BasicAppBar(text: '약속방이름', isProgressBar: false),
              InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration:
                      BoxDecoration(color: AppColors.grey100, boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3))
                  ]),
                  height: 90,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          ChatHeadText(text: '일시 | ', color: AppColors.grey500),
                          ChatHeadText(text: '받아온 날짜', color: Colors.black),
                        ],
                      ),
                      Row(
                        children: [
                          ChatHeadText(text: '시간 | ', color: AppColors.grey500),
                          ChatHeadText(text: '받아온 시간', color: Colors.black),
                        ],
                      ),
                      Row(
                        children: [
                          ChatHeadText(text: '장소 | ', color: AppColors.grey500),
                          ChatHeadText(text: '받아온 장소', color: Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: Container(
            padding: EdgeInsets.only(left: 4),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.grey300))),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: AppColors.mainBlue, size: 36),
                  onPressed: () {},
                ),
                Container(
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.grey400)
                          ),
                          child: Row(
                            children: [
                              Expanded(child: TextField(
                                focusNode: node,
                                controller: textController,
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none
                                ),
                              )),
                              IconButton(
                                  onPressed: () {
                                    sendChat(widget.id, userId, userName, textController.text); // 방번호, 유저번호, 유저이름, 메시지
                                    textController.clear();
                                  },
                                  icon: Icon(Icons.send))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatHeadText extends StatelessWidget {
  final String text;
  final Color color;

  const ChatHeadText({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color),
    );
  }
}
