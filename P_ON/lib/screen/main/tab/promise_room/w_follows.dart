import 'package:fast_app_base/common/constant/app_colors.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/w_following_list.dart';
import 'package:flutter/material.dart';

import 'friends_dummy.dart';
import 'w_followers_list.dart';

class Follows extends StatefulWidget {
  const Follows({super.key});

  @override
  State<Follows> createState() => _FollowsState();
}

class _FollowsState extends State<Follows> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: isSelected ? Colors.blue : Colors.grey))),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
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
                        color: isSelected ? AppColors.mainBlue : Colors.black)),
              ),
            )),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: !isSelected ? Colors.blue : Colors.grey))),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black;
                    } else {
                      return Colors.grey;
                    }
                  }),
                ),
                child: Text('Followers ${followersList.length}명',
                    style: TextStyle(
                        fontSize: 20,
                        color:
                            !isSelected ? AppColors.mainBlue : Colors.black)),
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
                              .map((followings) => FollowingsList(followings))
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
                          ...followersList
                              .map((followers) => FollowersList(followers))
                              .toList()
                        ],
                      ),
                    ),
                  ))
      ],
    );
  }
}
