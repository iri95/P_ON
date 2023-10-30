import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/promise_room/dto_promise.dart';
import 'package:flutter/material.dart';

class FollowersList extends StatelessWidget {
  final bool isSelected;
  final Friends followers;

  const FollowersList(this.followers, {super.key, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration:
          const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Row(
        children: [
          Image.asset(
            followers.userImage,
            width: 50,
          ),
          Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                followers.userName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
          Expanded(child: Container()),
          !isSelected
              ? FilledButton(
                  style: FilledButton.styleFrom(
                      minimumSize: const Size(75, 36),
                      backgroundColor: AppColors.mainBlue),
                  onPressed: () {},
                  child: const Text('추가'))
              : TextButton(
                  style: TextButton.styleFrom(
                      minimumSize: const Size(75, 36),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.mainBlue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () {},
                  child: const Text(
                    '해제',
                    style: TextStyle(color: AppColors.mainBlue),
                  ))
        ],
      ),
    );
  }
}
