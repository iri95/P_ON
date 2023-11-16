import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:p_on/screen/main/tab/chatbot/w_chatbot_example.dart';

import '../../user/fn_kakao.dart';
import '../../user/token_state.dart';

class ChatBot extends ConsumerStatefulWidget {
  final String Id;

  const ChatBot({super.key, required this.Id});

  @override
  ConsumerState<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends ConsumerState<ChatBot> {
  List<Map<String, dynamic>> messages = [];
  final messageController = TextEditingController();
  bool createSchedule = false;
  bool checkSchedule = false;
  final ScrollController _scrollController = ScrollController();
  final FocusNode node = FocusNode();

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
    var data = {'content': text};

    messages.add({'text': '일정이 생성되면 알려드릴게요!', 'user': false});

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
        method: 'POST',
        path: 'https://p-on.site/chatbot',
        headers: headers,
        data: data,
      );

      messages.add({'text' : '일정이 생성되었어요! 일정탭에서 확인해 보세요!!', 'user' : false});

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    } catch (e) {
      messages.add({'text': '유효하지 않은 입력이에요!', 'user': false});
    }
    setState(() {});
  }

  Future<void> getChatbot(String text) async {
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
    var data = {'content': text};

    messages.add({'text': '일정을 가져오는 중이에요!', 'user': false});

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });

    final apiService = ApiService();
    try {
      Response response = await apiService.sendRequest(
        method: 'GET',
        path: 'https://p-on.site/chatbot',
        headers: headers,
        data: data,
      );

      var res = await response.data['res'];
      messages.add({'text': '일정을 가져왔어요 확인해 보세요!', 'user': false});
      if (res.length > 0) {
        for (var item in res) {
          messages.add({
            'user': false,
            'schedule': true,
            'startDate': item['cal']['calendar_start_date'] ?? '미정',
            'endDate': item['cal']['calendar_end_date'] ?? '미정',
            'location': (item['cal']['calendar_place'] ?? '미정')
                .replaceAll(RegExp(r'<[^>]*>'), '')
                .replaceAll('&amp;', '&')
                .replaceAll('&lt;', '<')
                .replaceAll('&gt;', '>')
                .replaceAll('&quot;', '"')
                .replaceAll('&#39;', "'"),
            'title': item['cal']['calendar_title'] ?? '미정',
          });
        }
      } else {
        messages.add({'text': '일정이 없어요!', 'user': false});
      }

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    } catch (e) {
      messages.add({'text': '유효하지 않은 입력이에요!', 'user': false});
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd (E)', 'ko_KR');
    String formattedDate = formatter.format(now);

    messages.add({'text': formattedDate, 'user': false});
    messages.add({'text': '하고 싶은 채팅을 선택해 주세요!', 'user': false});
    messages.add({'text': '일정 생성', 'user': false});
    messages.add({'text': '일정 확인', 'user': false});

    node.addListener(() {
      if (node.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300)).then((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    node.dispose();
    messageController.dispose();
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
            'Pinky Chat',
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
                  controller: _scrollController,
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
                              messages[index]['text'],
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
                                    messages.add({
                                      'text': '생성할 일정을 말씀해주세요!',
                                      'user': false
                                    });
                                  });
                                },
                                child: Text(
                                  messages[2]['text'],
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
                                    messages.add({
                                      'text': '확인할 일정을 말씀해 주세요!',
                                      'user': false
                                    });
                                  });
                                },
                                child: Text(
                                  messages[3]['text'],
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
                      if (index - 1 != 3 &&
                          messages[index - 1]['user'] ==
                              messages[index]['user']) {
                        sameSender = true;
                      } else {
                        sameSender = false;
                      }
                      if (messages[index].containsKey('schedule')) {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 48,
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7, // 화면 너비의 80%를 최대 가로 길이로 설정
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      decoration: const BoxDecoration(
                                          color: AppColors.grey200,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 2),
                                              child: messages[index]
                                                          ['startDate'] ==
                                                      '미정'
                                                  ? const Row(
                                                      children: [
                                                        Text(
                                                          '시작 날짜',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: AppColors
                                                                  .pointOrange),
                                                        ),
                                                        Text(
                                                          ' 는 정해지지 않았고',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Pretendard'),
                                                        )
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          messages[index]
                                                              ['startDate'],
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              color: AppColors
                                                                  .pointOrange),
                                                        ),
                                                        const Text(
                                                          ' 부터',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Pretendard'),
                                                        )
                                                      ],
                                                    )),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 2),
                                            child: messages[index]['endDate'] ==
                                                    '미정'
                                                ? const Row(
                                                    children: [
                                                      Text(
                                                        '종료 날짜',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: AppColors
                                                                .pointOrange),
                                                      ),
                                                      Text(
                                                        ' 는 아직 정해지지 않았어요',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Pretendard'),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(
                                                        messages[index]
                                                            ['endDate'],
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: AppColors
                                                                .pointOrange),
                                                      ),
                                                      const Text(
                                                        ' 까지',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Pretendard'),
                                                      )
                                                    ],
                                                  ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 2),
                                            child: messages[index]['location'] =='미정' ? const Row(children: [
                                              Text('장소',style: TextStyle(
                                                  fontFamily:
                                                  'Pretendard',
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 16,
                                                  color: AppColors
                                                      .mainBlue)),
                                              Text('가 정해지지 않았어요!',style: TextStyle(
                                                  fontFamily:
                                                  'Pretendard'))
                                            ],) : Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      messages[index]
                                                          ['location'],
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Pretendard',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: AppColors
                                                              .mainBlue),
                                                    ),
                                                    const Text(
                                                      ' 에서',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Pretendard'),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 2),
                                            child: Row(
                                              children: [
                                                Text(
                                                  messages[index]['title'],
                                                  style: const TextStyle(
                                                      fontFamily: 'Pretendard'),
                                                ),
                                                const Text(
                                                  '약속이 있어요!',
                                                  style: TextStyle(
                                                      fontFamily: 'Pretendard'),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 8),
                              child: Row(
                                mainAxisAlignment: messages[index]['user']
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  if (messages[index]['user'] == false)
                                    Image.asset('assets/image/main/핑키1.png',
                                        width: 48),
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (messages[index]['user'] == false)
                                          const Text('핑키'),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8, // 화면 너비의 80%를 최대 가로 길이로 설정
                                          ),
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 4),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: messages[index]['user']
                                                  ? AppColors.pointOrange2
                                                  : AppColors.grey200,
                                              borderRadius: sameSender
                                                  ? const BorderRadius.all(
                                                      Radius.circular(20))
                                                  : messages[index]['user']
                                                      ? const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                        )
                                                      : const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                            ),
                                            child: Text(
                                              messages[index]['text'],
                                              style: const TextStyle(fontSize: 16),
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
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ChatbotExample();
                    },
                  );
                },
                child: ClipOval(
                  child: Container(
                      margin: const EdgeInsets.all(4),
                      child: Image.asset('assets/image/main/핑키1.png')),
                ),
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
                            focusNode: node,
                            controller: messageController,
                            cursorColor: AppColors.pointOrange,
                            decoration: const InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: '핑키를 누르시면 설명을 볼 수 있어요!'),
                            onSubmitted: (text) {
                              if (text.isEmpty) {
                                null;
                              } else {
                                setState(() {
                                  messageController.text = '';
                                  messages.add({'text': text, 'user': true});
                                  if (createSchedule == true &&
                                      checkSchedule == false) {
                                    postChatbot(text);
                                  } else if (checkSchedule == true &&
                                      createSchedule == false) {
                                    getChatbot(text);
                                  } else {
                                    messages.add({
                                      'text': '하고싶은 채팅을 먼저 선택해 주세요!',
                                      'user': false
                                    });
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
                                  messages.add({
                                    'text': messageController.text,
                                    'user': true
                                  });
                                  if (createSchedule == true &&
                                      checkSchedule == false) {
                                    postChatbot(messageController.text);
                                  } else if (checkSchedule == true &&
                                      createSchedule == false) {
                                    getChatbot(messageController.text);
                                  } else {
                                    messages.add({
                                      'text': '하고싶은 채팅을 먼저 선택해 주세요!',
                                      'user': false
                                    });
                                  }
                                  messageController.text = '';
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
