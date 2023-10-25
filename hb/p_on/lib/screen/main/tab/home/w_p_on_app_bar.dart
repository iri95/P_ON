import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../notification/s_notification.dart';

class PONAppBar extends StatefulWidget {
  static const double appBarHeight = 60;

  const PONAppBar({super.key});

  @override
  State<PONAppBar> createState() => _PONAppBar();
}

class _PONAppBar extends State<PONAppBar> {
  bool _showRedDot = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PONAppBar.appBarHeight,
      decoration: BoxDecoration(
          color: context.appColors.appBarBackground,
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: Row(
        children: [
          width10,
          Image.asset(
            "$basePath/main/핑키1.png",
            width: 32,
            fit: BoxFit.contain,
          ),
          Text('P:ON',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffff7f27))),
          emptyExpanded,
          Tap(
            onTap: () {
              //알림 화면
              Nav.push(const NotificationScreen());
            },
            child: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 32,
                  color: Colors.black,
                ),
                if (_showRedDot)
                  Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                        ),
                      ))
              ],
            ),
          ),
          width10,
          IconButton(
              onPressed: () {
                Nav.push(const NotificationScreen()); // 여기 설정화면으로 넘어가게 바꾸기
              },
              icon: Icon(
                Icons.settings_outlined,
                size: 32,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}
