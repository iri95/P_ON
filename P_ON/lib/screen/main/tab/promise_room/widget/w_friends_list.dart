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
      margin: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              ref.read(promiseProvider.notifier).removeFriends(widget.friends);
            },
            child: Stack(
              children: [
                ClipOval(
                  child: Image.network(
                    widget.friends.profileImage,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      // 에러 시 기본이미지
                      return const Icon(Icons.account_circle,
                          size: 44, color: Colors.grey);
                    },
                  ),
                ),
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
