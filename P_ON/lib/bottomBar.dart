import 'package:flutter/material.dart';
import 'package:p_on/historyScreen.dart';
import 'package:p_on/home.dart';
import 'package:p_on/myPageScreen.dart';
import 'package:p_on/planScreen.dart';

enum TabItem {
  home(Icons.home, '홈', homeScreen()),
  history(Icons.menu_book, '추억', historyScreen()),
  plan(Icons.calendar_today_outlined, '일정', planScreen()),
  myPage(Icons.person_outline_outlined, 'MY', myPageScreen());

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color:
          isActivated ? context.a : context.appColors.iconButtonInactivate,
        ),
        label: tabName);
  }
}