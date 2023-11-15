import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/util/dio.dart';

import '../../user/fn_kakao.dart';
import '../../user/token_state.dart';

class ChatBot extends ConsumerStatefulWidget {
  final String Id;

  const ChatBot({super.key, required this.Id});

  @override
  ConsumerState<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends ConsumerState<ChatBot> {
  List<Message> messages = [];
  final messageController = TextEditingController();
  bool createSchedule = false;
  bool checkSchedule = false;

  Future<void> postChatbot(String text) async {
    // 현재 저장된 서버 토큰을 가져옵니다.
    final loginState = ref.read(loginStateProvider);
    final token = loginState.serverToken;
    final id = loginState.id;

    var headers = {'Authorization': '$token', 'id': int.parse('$id')};

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
    var data = {
      'content' : text
    };
    print(text);
    print('post요청 보냄슨');
    print(headers['id'].runtimeType);


    messages.add(Message(text: '일정이 생성되면 알려드릴게요!', user: false));

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
        method: 'POST',
        path: 'https://p-on.site/chatbot',
        headers: headers,
        data: data,
      );
      print('이거보이면 데이터 받아온거임');
      print('이거보이면 데이터 받아온거임');
      print(response);
    } catch (e) {
      messages.add(Message(text: '유효하지 않은 입력이에요!', user: false));
    }
    setState(() {});
  }

  Future<void> getChatbot(String text) async {
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
        method: 'GET',
        path: 'http://k9e102.p.ssafy.io/chatbot',
        headers: headers,
        data: text,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd (E)', 'ko_KR');
    String formattedDate = formatter.format(now);

    messages.add(Message(text: formattedDate, user: false));
    messages.add(Message(text: '하고 싶은 채팅을 선택해 주세요!', user: false));
    messages.add(Message(text: '일정 생성', user: false));
    messages.add(Message(text: '일정 확인', user: false));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              context.go('/main');
            },
          ),
          title: Text(
            'Pinck Chat',
            style: GoogleFonts.fredokaOne(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.pointOrange),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: const EdgeInsets.only(bottom: 60, left: 8, right: 8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    if (index == 0 || index == 1) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0x80959CB1),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 24),
                            child: Text(
                              messages[index].text,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      );
                    } else if (index == 2) {
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.pointOrange,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                onPressed: () {
                                  createSchedule = true;
                                  checkSchedule = false;
                                  setState(() {
                                    messages.add(Message(
                                        text: '생성할 일정을 말씀해주세요!', user: false));
                                  });
                                },
                                child: Text(
                                  messages[2].text,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Pretendard',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.pointOrange,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                onPressed: () {
                                  createSchedule = false;
                                  checkSchedule = true;
                                  setState(() {
                                    messages.add(Message(
                                        text: '확인할 일정을 말씀해 주세요!', user: false));
                                  });
                                },
                                child: Text(
                                  messages[3].text,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Pretendard',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (index == 3) {
                      return Container();
                    } else {
                      var sameSender = false;
                      if (index - 1 != 3 && messages[index-1].user == messages[index].user) {
                        sameSender = true;
                      } else {
                        sameSender = false; 
                      }
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            child: Row(
                              mainAxisAlignment: messages[index].user
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (messages[index].user == false)
                                  Image.asset('assets/image/main/핑키1.png',
                                      width: 48),
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (messages[index].user == false)
                                        const Text('핑키'),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8, // 화면 너비의 80%를 최대 가로 길이로 설정
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: messages[index].user
                                                ? AppColors.pointOrange2
                                                : AppColors.grey200,
                                            
                                            borderRadius: sameSender ? BorderRadius.all(Radius.circular(20)) :
                                            messages[index].user
                                                ? const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                  )
                                                : const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                  ),
                                          ),
                                          child: Text(
                                            messages[index].text,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
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
              )
            ],
          ),
        ),
        bottomSheet: Container(
          width: double.infinity,
          height: 60,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.grey300),
            ),
          ),
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  margin: const EdgeInsets.all(4),
                    child: Image.asset('assets/image/main/핑키1.png')),
              ),
              
              Expanded(
                  child: Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.pointOrange),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            cursorColor: AppColors.pointOrange,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onSubmitted: (text) {
                              if (text.isEmpty) {
                                null;
                              } else {
                                setState(() {
                                  messageController.text = '';
                                  messages.add(Message(text: text, user: true));
                                  if (createSchedule == true &&
                                      checkSchedule == false) {
                                    postChatbot(text);
                                  } else if (checkSchedule == true &&
                                      createSchedule == false) {
                                    getChatbot(text);
                                  } else {
                                    messages.add(Message(
                                        text: '하고싶은 채팅을 먼저 선택해 주세요!',
                                        user: false));
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (messageController.text.isEmpty) {
                                null;
                              } else {
                                setState(() {
                                  messages.add(Message(
                                      text: messageController.text, user: true));
                                  if (createSchedule == true &&
                                      checkSchedule == false) {
                                    postChatbot(messageController.text);
                                  } else if (checkSchedule == true &&
                                      createSchedule == false) {
                                    getChatbot(messageController.text);
                                  } else {
                                    messages.add(Message(
                                        text: '하고싶은 채팅을 먼저 선택해 주세요!',
                                        user: false));
                                  }
                                  messageController.text='';
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: AppColors.pointOrange,
                            ))
                      ],
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool user;

  Message({required this.text, required this.user});
}
