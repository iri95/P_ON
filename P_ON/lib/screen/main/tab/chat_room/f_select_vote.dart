import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/chat_room/w_vote_items.dart';
import '../../../../common/cli_common.dart';
import '../promise_room/vo_server_url.dart';
import 'package:go_router/go_router.dart';
import 'package:p_on/screen/main/user/fn_kakao.dart';
import 'package:p_on/common/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/screen/main/user/token_state.dart';

class SelectVote extends ConsumerStatefulWidget {
  final String id;

  const SelectVote({super.key, required this.id});

  @override
  ConsumerState<SelectVote> createState() => _SelectVoteState();
}

class _SelectVoteState extends ConsumerState<SelectVote> {
  List<dynamic>? date;
  List<dynamic>? time;
  List<dynamic>? location;
  // String? userId;
  // bool? isComplete;
  // bool? isAnonymous;
  // bool? isMultipleChoice;
  // int? userCount;
  // Map<String, dynamic>? deadline;

  void getVote() async {
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
        path: '$server/api/promise/item/${widget.id}',
        headers: headers
      );

      date = await response.data['result'][0]['date'];
      time = await response.data['result'][0]['time'];
      location = await response.data['result'][0]['location'];

      setState(() {

      });


    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getVote();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            child: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  context.go('/chatroom/${widget.id}');
                },
              ),
              title: const Text('투표하기',
                  style:
                      TextStyle(fontFamily: 'Pretendard', color: Colors.black)),
              centerTitle: true,
              elevation: 0,
            ),
          ),
        ),
        body: ListView(
          children: [
            // 유저 정보 넘겨주기
            VoteItems(text: '일정', roomId: widget.id, voteData: date, voteType: 'date',),
            VoteItems(text: '시간', roomId: widget.id, voteData: time, voteType: 'time',),
            VoteItems(text: '장소', roomId: widget.id, voteData: location, voteType: 'location',),
          ],
        ),
      ),
    );
  }
}
