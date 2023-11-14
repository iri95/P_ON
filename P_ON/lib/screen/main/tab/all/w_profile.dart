import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/user/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import './friend_provider.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    final followingCount = ref.watch(followingCountProvider);
    final followingList = ref.watch(followingListProvider);
    final followerCount = ref.watch(followerCountProvider);
    final followerList = ref.watch(followerListProvider);

    final userState = ref.watch(userStateProvider);

    return Container(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.only(top: 20.0, left: 24, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${userState?.nickName ?? ''}",
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard')),
                  height20,
                  // 팔로워 팔로잉
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // TODO:
                          print('팔로워로 보기로 이동');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("팔로워",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Pretendard',
                                  color: AppColors.mainBlue,
                                )),
                            Text("${followerCount}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Pretendard',
                                  color: AppColors.mainBlue,
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(width: 25),
                      InkWell(
                        onTap: () {
                          // TODO:
                          print('팔로잉 보기로 이동');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("팔로잉",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Pretendard',
                                  color: AppColors.mainBlue,
                                )),
                            Text("${followingCount}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Pretendard',
                                  color: AppColors.mainBlue,
                                ))
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                GestureDetector(
                    onTap: () {
                      // TODO:
                      print("프로필수정으로이동");
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              NetworkImage(userState!.profileImage),
                        ),
                        // TODO: S3 연결 안해서 사진 선택 못함
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                              radius: 15,
                              backgroundColor: AppColors.mainBlue,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 14,
                              )),
                        )
                      ],
                    ))
              ])
            ],
          ),
        ),
      ],
    ));
  }
}
