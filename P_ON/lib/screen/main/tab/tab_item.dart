import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/all/f_all.dart';
import 'package:p_on/screen/main/tab/home/f_home.dart';
import 'package:p_on/screen/main/tab/schedule/f_schedule.dart';
import 'package:p_on/screen/main/tab/nothing/f_nothing.dart';
import 'package:flutter/material.dart';

import 'benefit/f_benefit.dart';

enum TabItem {
  home(Icons.home_outlined, '홈', HomeFragment()),
  history(Icons.menu_book, '추억', BenefitFragment()),
  blankField(null, '', NothingFragment()),
  plan(Icons.calendar_today_outlined, '일정', ScheduleFragment()),
  // plan(Icons.calendar_today_outlined, '일정', StockFragment()),
  my(Icons.person_outline, 'MY', AllFragment());

  final IconData? activeIcon;
  final IconData? inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage,
      {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  static TabItem find(String? name) {
    return values.asNameMap()[name] ?? TabItem.home;
  }

  BottomNavigationBarItem toNavigationBarItem(BuildContext context,
      {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color: isActivated
              ? context.appColors.navButton
              : context.appColors.navButtonInactivate,
        ),
        label: tabName);
  }
}
