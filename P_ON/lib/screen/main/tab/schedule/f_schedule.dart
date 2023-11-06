import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/fab/w_bottom_nav_floating_button.dart';
import 'package:p_on/screen/main/fab/w_bottom_nav_floating_button.riverpod.dart';
import 'package:p_on/screen/main/tab/home/w_p_on_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleFragment extends ConsumerStatefulWidget {
  const ScheduleFragment({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleFragment> createState() => _CalendarFragmentState();
}

class _CalendarFragmentState extends ConsumerState<ScheduleFragment> {
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      final floatingState = ref.read(floatingButtonStateProvider);

      if (scrollController.position.pixels > 100 && !floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(true);
      } else if (scrollController.position.pixels < 100 && floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const PONAppBar(),

          Expanded(
            child: RefreshIndicator(
              color: const Color(0xff3F48CC),
              backgroundColor: const Color(0xffFFBA20),
              // edgeOffset: PONAppBar.appBarHeight,
              onRefresh: () async {
                await sleepAsync(500.ms);
              },
              child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.only(top: PONAppBar.appBarHeight - 60, bottom: BottomFloatingActionButton.height,),
              children: [
                TableCalendar(
                  locale: 'ko_KR',
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2018, 10, 22),
                  lastDay: DateTime.utc(2030, 12, 9),

                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextFormatter: (date, locale) => DateFormat('yy년 MM월', locale).format(date),
                    titleTextStyle: const TextStyle(
                      fontSize: 20.0,
                      color:  AppColors.mainBlue,
                    ),
                    formatButtonVisible: false,
                    headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
                  ),
                ),
                Container(height: 500, color: Colors.green),
                Container(height: 500, color: Colors.orange),
                Container(height: 500, color: Colors.green),
                Container(height: 500, color: Colors.orange),
                Container(height: 500, color: Colors.green),
              ],
        ),
            ),
          ),
        ]
      ),
    );
  }
}
