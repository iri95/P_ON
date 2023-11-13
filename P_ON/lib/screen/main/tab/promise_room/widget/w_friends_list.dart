import 'package:p_on/common/common.dart';
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
              ref.read(promiseProvider.notifier).removeFriends(widget.friends);
            },
            child: Stack(
              children: [
                CircleAvatar(
                    backgroundColor: AppColors.mainBlue2,
                    child: Image.asset(
                        // widget.friends.profileImage,
                      'assets/image/main/핑키1.png',
                        width: 36)),
                const Positioned(
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: AppColors.mainBlue2,
                      radius: 8,
                      child: Icon(Icons.close, size: 10),
                    ))
              ],
            ),
          ),
          Text(widget.friends.nickName)
        ],
      ),
    );
  }
}
