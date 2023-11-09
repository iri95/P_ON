import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:p_on/screen/main/tab/chat_room/w_vote_items.dart';
import '../../../../common/cli_common.dart';
import '../promise_room/vo_server_url.dart';
import 'package:go_router/go_router.dart';

class SelectVote extends StatefulWidget {
  final String id;

  const SelectVote({super.key, required this.id});

  @override
  State<SelectVote> createState() => _SelectVoteState();
}

class _SelectVoteState extends State<SelectVote> {
  Map<String, dynamic>? date;
  Map<String, dynamic>? time;
  Map<String, dynamic>? location;
  // String? userId;
  // bool? isComplete;
  // bool? isAnonymous;
  // bool? isMultipleChoice;
  // int? userCount;
  // Map<String, dynamic>? deadline;

  void getVote() async {
    Dio dio = Dio();
    String url = '$server/api/vote/${widget.id}';

    var response = await dio.get(url);
    // 유저 정보 받아와서 비교해서 지금 현재 유저랑 만든사람이 동일하면 수정버튼 보이게 처리
    print('-=-=-=-=-=-=-==-=-=-=-=-=-=-');
    print('-=-=-=-=-=-=-==-=-=-=-=-=-=-');
    print('selecteVote 페이지임');
    print(response);
    print('-=-=-=-=-=-=-==-=-=-=-=-=-=-');
    print('-=-=-=-=-=-=-==-=-=-=-=-=-=-');

    date = response.data['result'][0]['date'];
    time = response.data['result'][0]['time'];
    location = response.data['result'][0]['location'];
    print(date);
    print(time);
    print(location);
    setState(() {
      // userId = response.data['userId'];
      // isComplete = response.data['isComplete'];
      // isAnonymous = response.data['isAnonymous'];
      // isMultipleChoice = response.data['isMultipleChoice'];
      // userCount = response.data['userCount'];
      // deadline = response.data['deadline'];
    });
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
