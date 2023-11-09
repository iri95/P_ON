import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:flutter/material.dart';

class FollowingsList extends ConsumerWidget {
  final bool isSelected;
  final Friends followings;

  const FollowingsList(this.followings, {super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promise = ref.watch(promiseProvider);
    final isAdded =
        promise.selected_friends?.any((item) => item.id == followings.id) ??
            false;
    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Row(
        children: [
          Image.asset(
            // followings['follow']['profileImage'],
            'assets/image/main/핑키1.png',
            width: 50,
          ),
          Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                followings.nickName,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard'),
              )),
          Expanded(child: Container()),
          FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: const Size(75, 36),
                  backgroundColor:
                      isAdded ? AppColors.grey200 : AppColors.mainBlue),
              onPressed: () {
                isAdded
                    ? ref
                        .read(promiseProvider.notifier)
                        .removeFriends(followings)
                    : ref.read(promiseProvider.notifier).addFriends(followings);
              },
              child: Text(isAdded ? '해제' : '추가', style: const TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500, color: Colors.white),))
        ],
      ),
    );
  }
}
