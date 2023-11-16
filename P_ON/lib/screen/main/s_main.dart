import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:p_on/screen/main/fab/w_scroll_bottom_history.dart';
import 'package:p_on/screen/main/fab/w_scroll_bottom_home.dart';
import 'package:p_on/screen/main/tab/tab_item.dart';
import 'package:p_on/screen/main/tab/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:p_on/screen/main/user/token_state.dart';

import '../../common/common.dart';
import '../../common/util/center_docked_style.dart';
import 'fab/w_bottom_nav_floating_button.dart';
import 'w_menu_drawer.dart';

final currentTabProvider = StateProvider((ref) => TabItem.home);

class MainScreen extends ConsumerStatefulWidget {
  final TabItem firstTab;

  const MainScreen({
    super.key,
    this.firstTab = TabItem.home,
  });

  @override
  ConsumerState<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
  DateTime? lastPressed;
  final tabs = TabItem.values;
  late final List<GlobalKey<NavigatorState>> navigatorKeys =
      TabItem.values.map((e) => GlobalKey<NavigatorState>()).toList();

  TabItem get _currentTab => ref.watch(currentTabProvider);

  int get _currentIndex => tabs.indexOf(_currentTab);

  GlobalKey<NavigatorState> get _currentTabNavigationKey =>
      navigatorKeys[_currentIndex];

  ///bottomNavigationBar 아래 영역 까지 그림
  bool get extendBody => true;

  static double get bottomNavigationBarBorderRadius => 30.0;
  static const double bottomNavigatorHeight = 60.0;

  bool isFabExpanded = false;

  String currentImage = 'assets/image/main/핑키3.png';

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    if (oldWidget.firstTab != widget.firstTab) {
      delay(() {
        ref.read(currentTabProvider.notifier).state = widget.firstTab;
      }, 0.ms);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPressed,
      child: Material(
        child: Stack(
          children: [
            Scaffold(
              body: Scaffold(
                  extendBody: extendBody,
                  //bottomNavigationBar 아래 영역 까지 그림
                  /// TODO: 테마컬러, 다크모드에 대한 설정 변경
                  drawer: const MenuDrawer(),
                  drawerEnableOpenDragGesture: false, //!Platform.isIOS,
                  body: Container(
                    padding: EdgeInsets.only(
                        bottom: extendBody
                            ? 60 - bottomNavigationBarBorderRadius
                            : 0),
                    child: SafeArea(
                      bottom: !extendBody,
                      child: pages,
                    ),
                  ),
                  resizeToAvoidBottomInset: false,
                  bottomNavigationBar: _buildBottomNavigationBar(context),
                  floatingActionButtonLocation: ref.read(fabLocationProvider),
                  // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: InkWell(
                    onHover: (e) {
                      setState(() {
                        currentImage = "assets/image/main/핑키3.png";
                      });
                    },
                    child: Container(
                      height: 75.0,
                      width: 75.0,
                      child: FittedBox(
                        child: FloatingActionButton(
                          elevation: 4,
                          onPressed: () {
                            final userId = ref.read(loginStateProvider).id;
                            final router = GoRouter.of(context);
                            router.push('/chatbot/$userId');
                          },
                          child: Image.asset(currentImage),
                        ),
                      ),
                    ),
                  )),
            ),
            Stack(
              children: [
                _buildScrollToUpWidget(_currentTab, TabItem.home, ScrollToUpHome()),
                _buildScrollToUpWidget(_currentTab, TabItem.history, ScrollToUpHistory()),
                AnimatedOpacity(
                  opacity: (_currentTab == TabItem.home ||
                          _currentTab == TabItem.plan)
                      ? 1
                      : 0,
                  duration: Duration(milliseconds: 300),
                  child: IgnorePointer(
                    ignoring: !(_currentTab == TabItem.home ||
                        _currentTab == TabItem.plan),
                    child: BottomFloatingActionButton(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  IndexedStack get pages => IndexedStack(
      index: _currentIndex,
      children: tabs
          .mapIndexed((tab, index) => Offstage(
                offstage: _currentTab != tab,
                child: TabNavigator(
                  navigatorKey: navigatorKeys[index],
                  tabItem: tab,
                ),
              ))
          .toList());

  Future<bool> _handleBackPressed() async {
    final isFirstRouteInCurrentTab =
        (await _currentTabNavigationKey.currentState?.maybePop() == false);
    if (isFirstRouteInCurrentTab) {
      if (_currentTab != TabItem.home) {
        _changeTab(tabs.indexOf(TabItem.home));
        return false;
      } else {
        // 사용자가 "뒤로" 버튼을 빠르게 두 번 누르면 앱이 종료되도록 합니다.
        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          // 2초 내에 두 번 눌러야 함
          // 처음 탭하거나 마지막 탭 이후 2초가 지난 경우
          lastPressed = now;

          // 사용자에게 메시지를 표시 (선택 사항)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('한 번 더 누르면 종료됩니다.'),
              duration: Duration(seconds: 2), // 스낵바 표시 지속 시간
              // behavior: SnackBarBehavior.floating,
            ),
          );

          return false;
        } else {
          // 빠르게 두 번 누른 경우
          return true;
        }
      }
    }
    // maybePop 가능하면 나가지 않는다.
    return isFirstRouteInCurrentTab;
  }

  Widget _buildScrollToUpWidget(TabItem currentTab, TabItem targetTab, Widget child) {
    return Opacity(
      opacity: 0,
      child: IgnorePointer(
        ignoring: currentTab != targetTab,
        child: child,
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: bottomNavigatorHeight + context.viewPaddingBottom,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bottomNavigationBarBorderRadius),
          topRight: Radius.circular(bottomNavigationBarBorderRadius),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: navigationBarItems(context),
          currentIndex: _currentIndex,
          selectedItemColor: context.appColors.navButton,
          unselectedItemColor: context.appColors.navButtonInactivate,
          onTap: _handleOnTapNavigationBarItem,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> navigationBarItems(BuildContext context) {
    return tabs
        .mapIndexed(
          (tab, index) => tab.toNavigationBarItem(
            context,
            isActivated: _currentIndex == index,
          ),
        )
        .toList();
  }

  void _changeTab(int index) {
    ref.read(currentTabProvider.notifier).state = tabs[index];
  }

  BottomNavigationBarItem bottomItem(bool activate, IconData iconData,
      IconData inActivateIconData, String label) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(label),
          activate ? iconData : inActivateIconData,
          color: activate
              ? context.appColors.iconButton
              : context.appColors.iconButtonInactivate,
        ),
        label: label);
  }

  void _handleOnTapNavigationBarItem(int index) {
    final oldTab = _currentTab;
    final targetTab = tabs[index];
    if (oldTab == targetTab) {
      final navigationKey = _currentTabNavigationKey;
      popAllHistory(navigationKey);
    }
    _changeTab(index);
  }

  void popAllHistory(GlobalKey<NavigatorState> navigationKey) {
    final bool canPop = navigationKey.currentState?.canPop() == true;
    if (canPop) {
      while (navigationKey.currentState?.canPop() == true) {
        navigationKey.currentState!.pop();
      }
    }
  }
}
