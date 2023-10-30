import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/widget/w_basic_appbar.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/dto_promise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

class SelectedFriends extends ConsumerStatefulWidget {
  const SelectedFriends({super.key});

  @override
  ConsumerState<SelectedFriends> createState() => _SelectedFriendsState();
}

class _SelectedFriendsState extends ConsumerState<SelectedFriends> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    final promise = ref.watch(promiseProvider);
    print('=================================test==========================');
    print('=================================test==========================');
    print('=================================test==========================');
    print('=================================test==========================');
    print(promise.promise_title);
    print('=================================test==========================');
    print('=================================test==========================');
    print('=================================test==========================');
    print('=================================test==========================');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const BasicAppBar(
                  text: '약속 생성', isProgressBar: true, percentage: 66),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                alignment: Alignment.topLeft,
                child:
                    '약속을 함께 할 친구를 추가해주세요'.text.black.size(16).semiBold.make(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 62,
                      margin: EdgeInsets.only(left: 32, right: 16),
                      decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          style: TextButton.styleFrom(primary: Colors.black),
                          onPressed: () {},
                          child: Column(
                            children: [Icon(Icons.search), Text('닉네임 검색')],
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 62,
                      margin: EdgeInsets.only(left: 16, right: 32),
                      decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          style: TextButton.styleFrom(primary: Colors.black),
                          onPressed: () {},
                          child: Column(
                            children: [Icon(Icons.link), Text('링크 복사')],
                          )),
                    ),
                  )
                ],
              ),
              Container(
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.only(top: 16),
                color: Colors.grey,
                // color: Color(0xffF4F7FA),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('선택된 친구 N명'),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xff778CE3),
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'assets/image/main/핑키1.png',
                                          width: 36,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: CircleAvatar(
                                        radius: 8,
                                        child: Positioned(
                                            child: Icon(
                                          Icons.close,
                                          size: 10,
                                        ))),
                                  )
                                ],
                              ),
                              Text('이름')
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color:
                                    isSelected ? Colors.blue : Colors.grey))),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isSelected = !isSelected;
                        });
                      },
                      child: Text('Followings NN명',
                          style: TextStyle(
                              fontSize: 20,
                              color: isSelected
                                  ? AppColors.mainBlue
                                  : Colors.black)),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black;
                          } else {
                            return Colors.grey;
                          }
                        }),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color:
                                    !isSelected ? Colors.blue : Colors.grey))),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isSelected = !isSelected;
                        });
                      },
                      child: Text('Followers NN명',
                          style: TextStyle(
                              fontSize: 20,
                              color: !isSelected
                                  ? AppColors.mainBlue
                                  : Colors.black)),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black;
                          } else {
                            return Colors.grey;
                          }
                        }),
                      ),
                    ),
                  )),
                ],
              )
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            width: double.infinity,
            height: 48,
            margin: EdgeInsets.all(14),
            child: FilledButton(
                style:
                    FilledButton.styleFrom(backgroundColor: AppColors.mainBlue),
                onPressed: () {},
                child: Text('다음')),
          ),
        ),
      ),
    );
  }
}
