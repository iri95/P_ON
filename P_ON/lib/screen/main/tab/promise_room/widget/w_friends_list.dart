import 'package:fast_app_base/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dto_promise.dart';

class FriendsList extends ConsumerStatefulWidget {
  final Friends friends;

  const FriendsList(this.friends, {super.key});

  @override
  ConsumerState<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends ConsumerState<FriendsList> {
  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(promiseProvider);
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // 해당유저 제거하는 코드 추가하기
            },
            child: Stack(
              children: [
                CircleAvatar(
                    backgroundColor: AppColors.mainBlue2,
                    child: Image.asset(widget.friends.userImage, width: 36)),
                const Positioned(
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: AppColors.mainBlue2,
                      radius: 8,
                      child: Icon(Icons.close, size: 10),
                    ))

                // Text(widget.friends.userName),
              ],
            ),
          ),
          Text(widget.friends.userName)
        ],
      ),
    );
  }
}
