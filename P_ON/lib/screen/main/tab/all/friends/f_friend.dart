import 'package:get/get.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:p_on/screen/main/tab/promise_room/f_last_create_promise.dart';
import 'package:p_on/screen/main/tab/promise_room/widget/w_follows.dart';
import 'package:p_on/screen/main/tab/promise_room/widget/w_friends_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:p_on/screen/main/tab/home/w_p_on_app_bar.dart';
import '../friend_provider.dart';
import 'w_friends_item.dart';

// import 'package:p_on/screen/main/tab/promise_room/'

class FriendsList extends ConsumerStatefulWidget {
  String selected;

  FriendsList({super.key, required this.selected});

  @override
  ConsumerState<FriendsList> createState() => _FriendsState();
}

class _FriendsState extends ConsumerState<FriendsList> {
  late String selected;
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
    isSelected = selected == 'following';
  }

  @override
  Widget build(BuildContext context) {
    final followingList = ref.watch(followingListProvider);
    final followerList = ref.watch(followerListProvider);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Nav.pop(context);
            },
          ),
          title: '친구'.text.bold.black.make(),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: 3))),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isSelected = true;
                      });
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return AppColors.grey100;
                          }
                          return Colors.transparent;
                        },
                      ),
                      foregroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black;
                        } else {
                          return Colors.grey;
                        }
                      }),
                    ),
                    child: Text('Followings ${followingList.length}명',
                        style: TextStyle(
                            fontSize: 20,
                            color: isSelected
                                ? AppColors.mainBlue
                                : Colors.black)),
                  ),
                )),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: !isSelected ? Colors.blue : Colors.grey,
                              width: 3))),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isSelected = false;
                      });
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return AppColors.grey100;
                          }
                          return Colors.transparent;
                        },
                      ),
                      foregroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black;
                        } else {
                          return Colors.grey;
                        }
                      }),
                    ),
                    child: Text('Followers ${followerList.length}명',
                        style: TextStyle(
                            fontSize: 20,
                            color: !isSelected
                                ? AppColors.mainBlue
                                : Colors.black)),
                  ),
                )),
              ],
            ),
            Expanded(
                child: isSelected
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 80),
                          child: Column(
                            children: [
                              ...followingList
                                  .map((followings) =>
                                      FriendsItem(followings, isSelected: true))
                                  .toList()
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 80),
                          child: Column(
                            children: [
                              ...followerList
                                  .map((followers) =>
                                      FriendsItem(followers, isSelected: false))
                                  .toList()
                            ],
                          ),
                        ),
                      ))
          ],
        ));
  }
}
