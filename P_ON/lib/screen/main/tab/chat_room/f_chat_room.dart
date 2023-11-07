import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/widget/w_basic_appbar.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';
import '../home/f_home.dart';
import '../promise_room/vo_server_url.dart';
import 'w_header_text_vote.dart';

class ChatRoom extends ConsumerStatefulWidget {
  final String id;

  const ChatRoom({super.key, required this.id});

  @override
  ConsumerState<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {
  final FocusNode node = FocusNode();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  double keyboardHeight = 0.0;
  bool isModalOpen = false;

  final Dio dio = Dio();
  late StompClient client;

  final String userId = "1";
  final String userName = "김태환";

  List<Map<String, dynamic>> messages = [];
  Map<String, dynamic> chatRoomInfo = {};

  var votesDate;
  var votesTime;
  var votesLocation;

  void onConnect(StompFrame? frame) {
    client.subscribe(
        destination: '/topic/chat/${widget.id}',
        callback: (frame) {
          if (frame.body != null) {
            Map<String, dynamic>? result = json.decode(frame.body!);
            Map<String, dynamic> newMessage = result!['body']['result'][0];
            setState(() {
              messages.add(newMessage);
            });
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease);
          } else {
            print('바디가 비었다 이말이야');
          }
        });
  }

  void sendChat(String roomId, String userId, String nickname, String content) {
    String destination = '/app/api/promise/chat/$roomId/$userId';
    Map<String, dynamic> message = {
      'sender': nickname,
      'chatType': 'TEXT',
      'content': content
    };

    client.send(
      destination: destination,
      body: jsonEncode(message),
    );

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  late final String formatedDate =
      DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(DateTime.now());

  void getChatRoom() async {
    final response = await dio.get('$server/api/promise/room/${widget.id}');
    chatRoomInfo = response.data['result'][0];

    print('==================================');
    print('==================================');
    print('==================================');
    print('==================================');
    print('==================================');
    print('==================================');
    print(response);
    print(response.data['result'][0]['votes']);
    // var votesDate = response.data['result'][0]['votes']['date'];
    // var votesTime = response.data['result'][0]['votes']['Time'];
    // var votesLocation = response.data['result'][0]['votes']['Location'];
  }

  @override
  void initState() {
    super.initState();
    getChatRoom();

    client = StompClient(
        config: StompConfig.sockJS(
            url: '$server/api/promise/ws-stomp',
            onConnect: onConnect,
            onWebSocketError: (dynamic error) => print(error)));

    client.activate();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      node.requestFocus();
    });

    node.addListener(() {
      if (node.hasFocus) {
        Future.delayed(Duration(milliseconds: 200)).then((_) {
          setState(() {
            keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          });
        });
        // 키보드가 활성화되면 ListView를 가장 아래로 스크롤합니다.
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              chatRoomInfo['promiseTitle'] ?? '...',
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black,),
              onPressed: () {
                // Nav.push(HomeFragment());
              },
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.menu, color: Colors.black))
            ],
          ),
          body: Container(
            padding: const EdgeInsets.only(bottom: 60),
            child: Column(
              children: [
                // BasicAppBar(text: chatRoomInfo['promiseTitle'] ?? '...', isProgressBar: false),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration:
                        BoxDecoration(color: AppColors.grey100, boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3))
                    ]),
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              const ChatHeadText(
                                  text: '일시 | ', color: AppColors.grey500),
                              if (chatRoomInfo['promiseDate'] == '미정')
                                Vote(
                                  voteType: VoteType.Date,
                                  roomId: widget.id,
                                  // isVote: votesDate
                                )
                              else
                                ChatHeadText(
                                    text: chatRoomInfo['promiseDate'] ?? '...',
                                    color: Colors.black),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              const ChatHeadText(
                                  text: '시간 | ', color: AppColors.grey500),
                              if (chatRoomInfo['promiseTime'] == '미정')
                                Vote(
                                  voteType: VoteType.Time,
                                  roomId: widget.id,
                                  // isVote: votesTime
                                )
                              else
                                ChatHeadText(
                                    text: chatRoomInfo['promiseTime'] ?? '...',
                                    color: Colors.black),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              const ChatHeadText(
                                  text: '장소 | ', color: AppColors.grey500),
                              if (chatRoomInfo['promiseLocation'] == '미정')
                                Vote(
                                  voteType: VoteType.Location,
                                  roomId: widget.id,
                                  // isVote : votesLocation
                                )
                              else
                                ChatHeadText(
                                    text: chatRoomInfo['promiseLocation'] ??
                                        '...',
                                    color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      bool isSameSender = false;
                      bool isDiffMinute = false;
                      bool isLastMessageFromSameSender = false;
                      bool isCurrentUser =
                          messages[index]['senderId'] == userId;

                      if (index != 0 &&
                          messages[index - 1]['senderId'] ==
                              messages[index]['senderId']) {
                        isSameSender = true;
                      }

                      if (index != messages.length - 1) {
                        if (messages[index]['senderId'] !=
                            messages[index + 1]['senderId']) {
                          isLastMessageFromSameSender = true;
                        }
                      } else {
                        isLastMessageFromSameSender = true;
                      }

                      if (index != 0 &&
                          DateTime.parse(messages[index - 1]['createAt'])
                                  .minute !=
                              DateTime.parse(messages[index]['createAt'])
                                  .minute) {
                        isDiffMinute = true;
                      }
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: isCurrentUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            // 유저이미지 넣기
                            !isSameSender && !isCurrentUser
                                ? Image.asset('assets/image/main/핑키1.png',
                                    width: 38)
                                : const SizedBox(
                                    width: 38,
                                  ),
                            Column(
                              children: [
                                if (!isSameSender && !isCurrentUser)
                                  Text(messages[index]['sender']),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.8, // 화면 너비의 80%를 최대 가로 길이로 설정
                                  ),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.only(left: 8, top: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: !isCurrentUser
                                        ? BoxDecoration(
                                            color: AppColors.grey200,
                                            borderRadius: !isSameSender
                                                ? const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20))
                                                : BorderRadius.circular(20))
                                        : BoxDecoration(
                                            color: AppColors.mainBlue2,
                                            borderRadius:
                                                isLastMessageFromSameSender
                                                    ? const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20))
                                                    : BorderRadius.circular(
                                                        20)),
                                    child: Text(
                                      messages[index]['content'],
                                      style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 16,
                                          color: !isCurrentUser
                                              ? AppColors.black1
                                              : AppColors.grey50),
                                    ),
                                  ),
                                ),

                                ////////////////////////////////
                                // 시간표시 로직 태환이형한테 물어보자
                                if (isLastMessageFromSameSender ||
                                    !isLastMessageFromSameSender &&
                                        isDiffMinute ||
                                    isLastMessageFromSameSender && isDiffMinute)
                                  Container(
                                    margin: EdgeInsets.only(left: 4),
                                    child: Text(
                                      DateFormat('a hh:mm', 'ko_KR').format(
                                          DateTime.parse(
                                              messages[index]['createAt'])),
                                      style: const TextStyle(
                                          color: AppColors.grey500,
                                          fontSize: 12),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          bottomSheet: Container(
            padding: EdgeInsets.only(
                left: 4, bottom: isModalOpen ? keyboardHeight : 0),
            height: isModalOpen ? keyboardHeight + 60 : 60,
            width: double.infinity,
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.grey300))),
            child: Row(
              children: [
                IconButton(
                  icon: isModalOpen
                      ? const Icon(Icons.close,
                          color: AppColors.mainBlue, size: 36)
                      : const Icon(Icons.add,
                          color: AppColors.mainBlue, size: 36),
                  onPressed: () {
                    setState(() {
                      isModalOpen = !isModalOpen;
                    });
                    if (isModalOpen) {
                      showModalBottomSheet(
                        barrierColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Container(
                            height: keyboardHeight,
                            color: Colors.red,
                          );
                        },
                      );
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.grey400)),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                              focusNode: node,
                              controller: textController,
                              decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                            )),
                            IconButton(
                                onPressed: () {
                                  if (node.hasFocus) {
                                    sendChat(
                                        widget.id,
                                        userId,
                                        userName,
                                        textController
                                            .text); // 방번호, 유저번호, 유저이름, 메시지
                                    textController.clear();
                                  } else {}
                                },
                                icon: node.hasFocus
                                    ? const Icon(Icons.send, color: AppColors.mainBlue,)
                                    : const Icon(Icons.mic, color: AppColors.mainBlue,))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
