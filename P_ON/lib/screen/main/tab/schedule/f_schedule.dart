import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/common.dart';
import 'package:p_on/screen/main/fab/w_bottom_nav_floating_button.dart';
import 'package:p_on/screen/main/fab/w_bottom_nav_floating_button.riverpod.dart';
import 'package:p_on/screen/main/tab/home/w_p_on_app_bar.dart';
import 'package:p_on/screen/main/tab/promise_room/vo_server_url.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleFragment extends ConsumerStatefulWidget {
  const ScheduleFragment({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleFragment> createState() => _CalendarFragmentState();
}

class _CalendarFragmentState extends ConsumerState<ScheduleFragment> {
  final scrollController = ScrollController();
  final Dio dio = Dio();
  static double get calendarBorderRadius => 30.0;
  static const double calendarHeight = 384.0;

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  void getPromiseList() async {
    print('$server/api/promise/room-list/1');

    final response = await dio.get('$server/api/promise/room-list/1');
    print('==================================');
    print('==================================');
    print('==================================');
    print('==================================');
    print('==================================');
    print('==================================');
    print(response);
  }

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
    getPromiseList();
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
                Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 5.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    side: BorderSide( color:Colors.black26, width: 1.0),
                  ),
                  child: TableCalendar(

                    locale: 'ko_KR',
                    focusedDay: DateTime.now(),
                    firstDay: DateTime.utc(2018, 10, 22),
                    lastDay: DateTime.utc(2030, 12, 9),
                    daysOfWeekHeight: 40.0,
                    onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                      // 선택된 날짜의 상태를 갱신합니다.
                      setState((){
                        this.selectedDay = selectedDay;
                        this.focusedDay = focusedDay;
                      });
                    },
                    selectedDayPredicate: (DateTime day) {
                      // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
                      return isSameDay(selectedDay, day);
                    },

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
                    // eventLoader: ,
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
