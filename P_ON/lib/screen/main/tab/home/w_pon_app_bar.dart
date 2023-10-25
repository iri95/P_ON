import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../notification/s_notification.dart';

class POnAppBar extends StatefulWidget {
  static const double appBarHeight = 60;

  const POnAppBar({super.key});

  @override
  State<POnAppBar> createState() => _POnAppBarState();
}

class _POnAppBarState extends State<POnAppBar> {
  bool _showRedDot = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: POnAppBar.appBarHeight,
      color: context.appColors.appBarBackground,
      child: Row(
        children: [
          width10,
          Image.asset(
            "$basePath/icon/toss.png",
            height: 30,
          ),
          emptyExpanded,
          Image.asset(
            "$basePath/icon/map_point.png",
            height: 30,
          ),
          width10,
          Tap(
            onTap: () {
              //알림 화면
              Nav.push(const NotificationScreen());
            },
            child: Stack(
              children: [
                Image.asset(
                  "$basePath/icon/notification.png",
                  height: 30,
                ),
                if (_showRedDot)
                  Positioned.fill(
                      child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    ),
                  ))
              ],
            ),
          ),
          width10,
        ],
      ),
    );
  }
}
