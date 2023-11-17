import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nav/nav.dart';
import 'package:p_on/common/constant/app_colors.dart';

class ChatbotExample extends StatefulWidget {
  const ChatbotExample({super.key});

  @override
  State<ChatbotExample> createState() => _ChatbotExampleState();
}

class _ChatbotExampleState extends State<ChatbotExample> {
  final controller = PageController();
  var isLastPage = false;
  var isFirstPage = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final currentPage = controller.page?.roundToDouble();
      if (currentPage != null) {
        setState(() {
          isFirstPage = currentPage == 0;
          isLastPage = currentPage == 3;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Container(
        padding: const EdgeInsets.only(left: 12),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            color: AppColors.pointOrange2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '핑키 사용 방법',
              style: GoogleFonts.jua(color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Nav.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 350,
        height: 400,
        child: PageView(
          controller: controller,
          children: <Widget>[
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 6, horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: AppColors.pointOrange,
                  ),
                  child: const Text(
                    '일정 생성',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '버튼을 클릭후 대화를 입력하면',
                  style: GoogleFonts.jua(fontSize: 20),
                ),
                Text(
                  '일정이 생성되요!',
                  style: GoogleFonts.jua(fontSize: 20),
                ),
                Container(
                  margin:
                  const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    '예시 문장',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.grey300),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: const Text(
                            '핑키',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Pretendard'),
                          ),
                        ),
                        Container(
                          margin:
                          const EdgeInsets.only(left: 12, bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color: AppColors.grey200),
                          child: const Text(
                            '생성할 일정을 말씀해 주세요!',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Pretendard'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          color: AppColors.pointOrange2),
                      child: const Text(
                        '11월 18일 서면에서 3차 회식이야',
                        style: TextStyle(
                            fontSize: 16, fontFamily: 'Pretendard'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: const Text(
                            '핑키',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Pretendard'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 4, left: 12, right: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color: AppColors.grey200),
                          child: const Text(
                            '일정이 생성되면 알려드릴게요!',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Pretendard'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: const Text(
                      '*정확한 일정 생성을 위해 날짜와 장소를 말씀해주세요!',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.mainBlue,
                          fontStyle: FontStyle.italic),
                    ))
              ],
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 6, horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: AppColors.pointOrange,
                  ),
                  child: const Text(
                    '일정 확인',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '버튼을 클릭후 대화를 입력하면',
                  style: GoogleFonts.jua(fontSize: 20),
                ),
                Text(
                  '일정을 확인할 수 있어요!',
                  style: GoogleFonts.jua(fontSize: 20),
                ),
                Container(
                  margin:
                  const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    '예시 문장',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.grey300),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: const Text(
                            '핑키',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Pretendard'),
                          ),
                        ),
                        Container(
                          margin:
                          const EdgeInsets.only(left: 12, bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color: AppColors.grey200),
                          child: const Text(
                            '확인할 일정을 말씀해 주세요!',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Pretendard'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          color: AppColors.pointOrange2),
                      child: const Text(
                        '이번주 일정 알려줘',
                        style: TextStyle(
                            fontSize: 16, fontFamily: 'Pretendard'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: const Text(
                            '핑키',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Pretendard'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 4, left: 12, right: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color: AppColors.grey200),
                          child: const Text(
                            '일정을 가져왔어요 확인해보세요!',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Pretendard'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: const Text(
                      '*정확한 일정 확인을 위해 날짜를 말씀해주세요!',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.mainBlue,
                          fontStyle: FontStyle.italic),
                    ))
              ],
            ),
            Column(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      '가져온 일정은 이렇게 표시되요!',
                      style: GoogleFonts.jua(fontSize: 20),
                    )),
                Container(
                  margin:
                  const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    '예시 문장',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.grey300),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: const Text(
                            '핑키',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Pretendard'),
                          ),
                        ),
                        Container(
                          margin:
                          const EdgeInsets.only(left: 12, bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color: AppColors.grey200),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '2023년 11월 6일',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        color: AppColors.pointOrange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ' 에',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Pretendard'),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'SSAFY 부울경 캠퍼스',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        color: AppColors.mainBlue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ' 에서',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Pretendard'),
                                  ),
                                ],
                              ),
                              Text(
                                '김태환 취업 이 있어요',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'Pretendard'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin:
                  const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    '일정이 없는 경우',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.grey300),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 4, left: 12, right: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color: AppColors.grey200),
                          child: const Text(
                            '일정이 없어요!',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Pretendard'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: const Text(
                      '*정확한 일정 확인을 위해 날짜를 말씀해주세요!',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.mainBlue,
                          fontStyle: FontStyle.italic),
                    ))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/image/main/login.png', width: 300, height: 200,),
                Text(
                  '이제 핑키와 함께',
                  style: GoogleFonts.jua(fontSize: 20),
                ),
                Text(
                  '일정을 잡고 확인해 보세요!',
                  style: GoogleFonts.jua(fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    Nav.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.pointOrange
                    ),
                    child: Text('확인', style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),),
                  ),
                )

              ],
            )
          ],
        ),
      ),
      actions: [
        if (!isFirstPage)
        IconButton(
          onPressed: () {
            controller.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        if (!isLastPage)
        IconButton(
          onPressed: () {
            controller.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          icon: Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }
}
