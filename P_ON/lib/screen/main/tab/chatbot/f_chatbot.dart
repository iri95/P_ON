import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p_on/common/common.dart';

class ChatBot extends StatefulWidget {
  final String Id;

  const ChatBot({super.key, required this.Id});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
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
          padding: const EdgeInsets.only(bottom: 60),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0x80959CB1),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 24),
                          child: Text(
                            '테스트날짜',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('assets/image/main/핑키1.png',
                                  width: 48),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('핑키'),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.8, // 화면 너비의 80%를 최대 가로 길이로 설정
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: AppColors.grey200,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                        ),
                                        child: Text(
                                          '채팅',
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
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mic,
                    color: AppColors.pointOrange,
                  )),
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
                        const Expanded(
                          child: TextField(
                            cursorColor: AppColors.pointOrange,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
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
