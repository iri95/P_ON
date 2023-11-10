import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:p_on/common/common.dart';
import 'package:table_calendar/table_calendar.dart';

class RightModal extends StatefulWidget {
  int id;

  RightModal({super.key, required this.id});

  @override
  State<RightModal> createState() => _RightModalState();
}

class _RightModalState extends State<RightModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.mainBlue3,
        width: MediaQuery.of(context).size.width - 60,
        height: double.infinity,
        child: SafeArea(
            child: Column(
          children: [
            Text('${widget.id}'),
            Text('모두의 일정'),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.grey50
              ),
              child: TableCalendar(
                locale: 'ko_KR',
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2018, 10, 22),
                lastDay: DateTime.utc(2030, 12, 9),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      DateFormat('yy년 MM월', locale).format(date),
                  titleTextStyle: const TextStyle(
                    fontSize: 20.0,
                    color: AppColors.mainBlue,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                  formatButtonVisible: false,
                  headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
                ),
                // eventLoader: ,
              ),
            ),
          ],
        )));
  }
}
