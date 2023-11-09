import 'package:p_on/screen/notification/w_notification_item.dart';
import 'package:flutter/material.dart';

import 'd_notification.dart';
import 'notifications_dummy.dart';

import 'package:p_on/common/common.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // TODO: 앱바 다른 것과 통일
        slivers: [
          const SliverAppBar(
            title: Text("알림"),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '읽은 알림 삭제', // 첫 번째 텍스트
                    style: TextStyle(
                      fontSize: 18, // 원하는 폰트 크기
                      fontWeight: FontWeight.w600, // 원하는 폰트 굵기
                      color: AppColors.grey600, // 원하는 텍스트 색상
                    ),
                    // onTap: () {
                    //   // TODO: 읽은 알림 모두 삭제하는 로직 추가
                    //   print('읽은알림삭제해줘')
                    // },
                  ),
                  SizedBox(width: 10), // 텍스트 간 간격 조절
                  Text(
                    '모두 읽음', // 두 번째 텍스트
                    style: TextStyle(
                      fontSize: 18, // 원하는 폰트 크기
                      fontWeight: FontWeight.w600, // 원하는 폰트 굵기
                      color: AppColors.grey600, // 원하는 텍스트 색상
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => NotificationItemWidget(
                notification: notificationDummies[index],
                onTap: () {
                  NotificationDialog(
                      [notificationDummies[0], notificationDummies[1]]).show();
                },
              ),
              childCount: notificationDummies.length,
            ),
          )
        ],
      ),
    );
  }
}
