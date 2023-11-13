import 'package:p_on/common/common.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import './vo/vo_notification.dart';

class NotificationItemWidget extends StatefulWidget {
  final MyNotification notification;
  final VoidCallback onTap;

  const NotificationItemWidget(
      {required this.onTap, super.key, required this.notification});

  @override
  State<NotificationItemWidget> createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {
  static const leftPadding = 15.0;

  @override
  void initState() {
    // _isRead = widget.notification.isRead;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: widget.notification.isRead
            ? AppColors.grey200 // 읽은거
            : Colors.white, // 안읽은거
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Width(leftPadding),
                      // 분류
                      widget.notification.type.text
                          .size(16)
                          .color(widget.notification.isRead
                              ? AppColors.grey500
                              : AppColors.grey700)
                          .make(),
                      emptyExpanded,
                      // 남은 시간
                      timeago
                          .format(widget.notification.time,
                              locale: context.locale.languageCode)
                          .text
                          .size(14)
                          .color(context.appColors.lessImportant)
                          .make(),
                      width10,
                    ],
                  ),
                ],
              ),
            ),
            // 메시지
            widget.notification.description.text
                .size(18)
                .make()
                .pOnly(left: leftPadding)
          ],
        ),
      ),
    );
  }
}
