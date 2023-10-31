import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/tab/all/f_all.dart';
import 'package:p_on/screen/main/tab/home/f_home.dart';
import 'package:p_on/screen/main/tab/stock/f_stock.dart';
import 'package:p_on/screen/main/tab/ttospay/f_ttospay.dart';
import 'package:flutter/material.dart';

import 'benefit/f_benefit.dart';

enum TabItem {
  home(Icons.home_outlined, '홈', HomeFragment()),
  history(Icons.menu_book, '추억', BenefitFragment()),
  blankFeild(Icons.check_box_outline_blank, '', TtospayFragment()),
  plan(Icons.calendar_today_outlined, '일정', StockFragment()),
  my(Icons.person_outline, 'MY', AllFragment());

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
              isActivated ? context.appColors.navButton : context.appColors.navButtonInactivate,
        ),
        label: tabName);
  }
}
