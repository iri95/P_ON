import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../notification/s_notification.dart';

class PONAppBar extends StatefulWidget {
  static const double appBarHeight = 60.0;

  const PONAppBar({super.key});

  @override
  State<PONAppBar> createState() => _PONAppBar();
}

class _PONAppBar extends State<PONAppBar> {
  // TODO: 안읽은 알림이 있으면 true, 없으면 false
  bool _showRedDot = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      height: PONAppBar.appBarHeight,
      decoration: BoxDecoration(
          color: context.appColors.appBarBackground,
          border:
              const Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: Row(
        children: [
          width10,
          Image.asset(
            "$basePath/main/핑키1.png",
            width: 32,
            fit: BoxFit.contain,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text('P:ON',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xffff7f27)))),
          emptyExpanded,
          Tap(
            onTap: () {
              //TODO: 알림 화면으로 이동
              Nav.push(const NotificationScreen());
            },
            child: Stack(
              children: [
                const Icon(
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
                // TODO: 여기 검색화면으로 넘어가게 바꾸기
                Nav.push(const NotificationScreen());
              },
              icon: const Icon(
                Icons.search,
                size: 32,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}
