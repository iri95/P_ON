import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/chat_room/dto_vote.dart';
import 'package:p_on/screen/main/tab/chat_room/w_right_modal.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';
import '../promise_room/vo_server_url.dart';
import 'w_header_text_vote.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:p_on/screen/main/user/token_state.dart';

class ChatRoom extends ConsumerStatefulWidget {
  final int id;

  const ChatRoom({super.key, required this.id});

  @override
  ConsumerState<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {
  // 텍스트필드 컨트롤러
  final FocusNode node = FocusNode();
  final TextEditingController textController = TextEditingController();

  // Expanded의 스크롤 컨트롤러
  final ScrollController _scrollController = ScrollController();

  // endDrawer의 키값
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // + 버튼의 모달창 높이 및 활성화 여부
  double keyboardHeight = 0.0;
  bool isModalOpen = false;
  final Dio dio = Dio();
  late StompClient client;
  List<Map<String, dynamic>> messages = [];
  Map<String, dynamic> chatRoomInfo = {};
  String? userId;
  List<dynamic>? userData;

  var isDate;
  var isTime;
  var isLocation;

  // 채팅방 소켓통신 연결
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
            print('현재 채팅목록들');
            print(messages);
            print('마지막 채팅기록');
            print(messages.last);

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });


          } else {
            print('바디가 비었다 이말이야');
          }
        });
  }

  // 메시지 보내기
  void sendChat(int roomId, String? userId, String content) {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final id = loginState.id;

    String destination = '/app/api/promise/chat/$roomId';
    Map<String, dynamic> message = {
      'chatType': 'TEXT',
      'content': content,
      'senderId': userId
    };

    client.send(
      destination: destination,
      headers: {'id': '$id'},
      body: jsonEncode(message),
    );
    print('채팅보냄');
  }

  // 마지막 채팅 로그 전송하기
  Future<void> sendChatLog() async {
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
        method: 'PUT',
        path: '$server/api/promise/chat/${messages.last['roomId']}/${messages.last['id']}',
        headers: headers
      );
      print('마지막 채팅 기록 저장');
    } catch (e) {
      print(e);
    }
  }

  // 채팅방 정보 받아오기
  Future<void> getChatRoom() async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;
    final voteInfo = ref.read(voteInfoProvider);

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
          method: 'GET',
          path: '$server/api/promise/room/${widget.id}',
          headers: headers);
      chatRoomInfo = response.data['result'][0];
      print('==================================');
      print('==================================');
      print('==================================');
      print('==================================');
      print('==================================');
      print('==================================');
      print(response);
      print(response.data['result'][0]['votes']);

      isDate = await response.data['result'][0]['date'];
      isTime = await response.data['result'][0]['time'];
      isLocation = await response.data['result'][0]['location'];
      voteInfo.create_user = await response.data['result'][0]['userId'];
      voteInfo.is_anonymous = await response.data['result'][0]['anonymous'];
      voteInfo.is_multiple_choice =
          await response.data['result'][0]['multipleChoice'];
      voteInfo.dead_date = await response.data['result'][0]['deadDate'];
      voteInfo.dead_time = await response.data['result'][0]['deadTime'];
      userData = await response.data['result'][0]['users'];

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  // 채팅방 이전 채팅기록 불러오기
  Future<void> getChat() async {
    final Dio dio = Dio();
    var response = await dio.get('$server/api/promise/chat/${widget.id}');

    print(response.data['result']);
  }

  late final String formatedDate =
      DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(DateTime.now());

  String changeDate(String date) {
    if (date == null) {
      return '...';
    }
    DateTime chatRoomDate = DateTime.parse(date);
    DateFormat formatter = DateFormat('yyyy-MM-dd (E)', 'ko_kr');
    String formatterDate = formatter.format(chatRoomDate);
    return formatterDate;
  }

  @override
  void initState() {
    super.initState();
    getChatRoom();
    getChat();
    userId = ref.read(loginStateProvider).id;
    Map<String, dynamic> formatedDateMap = {'today': formatedDate};
    messages.add(formatedDateMap);

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
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // sendChatLog();
    client.deactivate();
    textController.dispose();
    _scrollController.dispose();
    node.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(messages);
    print(messages.length);
    print(widget.id);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
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
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              context.go('/main');
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                icon: const Icon(Icons.menu, color: Colors.black))
          ],
        ),
        endDrawer: RightModal(id: widget.id, users: userData),
        body: Container(
          padding: const EdgeInsets.only(bottom: 60),
          child: Column(
            children: [
              // BasicAppBar(text: chatRoomInfo['promiseTitle'] ?? '...', isProgressBar: false),
              InkWell(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
                            if (chatRoomInfo['promiseDate'] == null ||
                                chatRoomInfo['promiseDate'] == '미정')
                              if (isDate == null)
                                const ChatHeadText(
                                    text: '...', color: Colors.black)
                              else
                                Vote(
                                  voteType: VoteType.DATE,
                                  roomId: widget.id,
                                  isVote: isDate,
                                  voteInfo: chatRoomInfo['promiseDate'],
                                )
                            else
                              ChatHeadText(
                                  text:
                                      changeDate(chatRoomInfo['promiseDate']) ??
                                          '...',
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
                            if (chatRoomInfo['promiseTime'] == null ||
                                chatRoomInfo['promiseTime'] == '미정')
                              if (isTime == null)
                                const ChatHeadText(
                                    text: '...', color: Colors.black)
                              else
                                Vote(
                                  voteType: VoteType.TIME,
                                  roomId: widget.id,
                                  isVote: isTime,
                                  voteInfo: chatRoomInfo['promiseTime'],
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
                            if (chatRoomInfo['promiseLocation'] == null ||
                                chatRoomInfo['promiseLocation'] == '미정')
                              if (isLocation == null)
                                const ChatHeadText(
                                    text: '...', color: Colors.black)
                              else
                                Vote(
                                  voteType: VoteType.LOCATION,
                                  roomId: widget.id,
                                  isVote: isLocation,
                                  voteInfo: chatRoomInfo['promiseLocation'],
                                )
                            else
                              ChatHeadText(
                                  text:
                                      chatRoomInfo['promiseLocation'] ?? '...',
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
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    if (messages[index].containsKey('today')) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0x80959CB1),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 24
                            ),
                            child: Text(
                              messages[index]['today'],
                              style: const TextStyle(color: Colors.white),
                            )
                          ),
                        ],
                      );
                    } else {
                      bool isSameSender = false;
                      bool isLastMessageFromSameSender = false;
                      bool isCurrentUser = index != 0 &&
                          messages[index]['senderId'] ==
                              ref.read(loginStateProvider).id;
                      if (index != 0 &&
                          messages[index - 1]['senderId'] ==
                              messages[index]['senderId']) {
                        isSameSender = true;
                      }
                      if (index != 0 && index != messages.length - 1) {
                        if (messages[index]['senderId'] !=
                            messages[index + 1]['senderId']) {
                          isLastMessageFromSameSender = true;
                        }
                      } else {
                        isLastMessageFromSameSender = true;
                      }
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
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

                                // 채팅시간표시 부분 지금 보내는 사람이 나라면 채팅의 왼쪽에 표시
                                if (isCurrentUser)
                                  Container(
                                    child: Text(
                                      DateFormat('a hh:mm', 'ko_KR').format(
                                          DateTime.parse(
                                              messages[index]['createAt'])),
                                      style: const TextStyle(
                                          color: AppColors.grey500,
                                          fontSize: 12),
                                    ),
                                  ),


                                if (!isSameSender && !isCurrentUser)
                                  Text(messages[index]['sender']),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%를 최대 가로 길이로 설정
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 8, top: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: !isCurrentUser
                                        ? BoxDecoration(
                                            color: AppColors.grey200,
                                            borderRadius: !isSameSender
                                                ? const BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                )
                                                : BorderRadius.circular(20),
                                        )
                                        : BoxDecoration(
                                            color: AppColors.mainBlue2,
                                            borderRadius:
                                                isLastMessageFromSameSender
                                                    ? const BorderRadius.only(
                                                        topLeft: Radius.circular(20),
                                                        topRight: Radius.circular(20),
                                                        bottomLeft: Radius.circular(20))
                                                    : BorderRadius.circular(20)),
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
                                if (!isCurrentUser)
                                  Container(
                                    child: Text(
                                      DateFormat('a hh:mm', 'ko_KR').format(
                                          DateTime.parse(
                                              messages[index]['createAt'])),
                                      style: const TextStyle(
                                          color: AppColors.grey500,
                                          fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              Container(
                height: 10,
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
                                if (textController.text.isNotEmpty) {
                                  sendChat(
                                      widget.id,
                                      userId,
                                      textController
                                          .text); // 방번호, 유저번호, 유저이름, 메시지
                                  textController.clear();
                                } else { null; }
                              },
                              icon: const Icon(
                                Icons.send,
                                color: AppColors.mainBlue,
                              ))
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
    );
  }
}
