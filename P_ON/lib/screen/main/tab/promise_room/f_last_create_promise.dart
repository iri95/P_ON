import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_on/common/constant/app_colors.dart';
import 'package:p_on/common/widget/w_basic_appbar.dart';
import 'package:p_on/screen/main/tab/promise_room/dto_promise.dart';
import 'package:p_on/screen/main/tab/promise_room/f_search_naver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:nav/nav.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:velocity_x/velocity_x.dart';
import 'widget/w_checked_modal.dart';

class LastCreatePromise extends ConsumerStatefulWidget {
  const LastCreatePromise({super.key});

  @override
  ConsumerState<LastCreatePromise> createState() => _LastCreatePromiseState();
}

class _LastCreatePromiseState extends ConsumerState<LastCreatePromise> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  final FocusNode dateNode = FocusNode();
  final FocusNode timeNode = FocusNode();
  final FocusNode placeNode = FocusNode();

  Future<void> _selectDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.mainBlue2,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style:
                    TextButton.styleFrom(foregroundColor: AppColors.mainBlue),
              )),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateController.text =
          DateFormat('yyyy-MM-dd (E)', 'ko_kr').format(picked);
      ref.read(promiseProvider.notifier).setPromiseDate(picked);
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay t = TimeOfDay.now();
    Navigator.of(context).push(showPicker(
        context: context,
        value: Time(hour: t.hour, minute: t.minute),
        onChange: (TimeOfDay time) {
          final period = time.period == DayPeriod.am ? '오전' : '오후';
          timeController.text =
              '$period ${time.hourOfPeriod.toString().padLeft(2, '0')}시 ${time.minute.toString().padLeft(2, '0')}분';
          ref
              .read(promiseProvider.notifier)
              .setPromiseTime(timeController.text);
        },
        minuteInterval: TimePickerInterval.FIVE,
        iosStylePicker: true,
        okText: '확인',
        okStyle: const TextStyle(color: AppColors.mainBlue2),
        cancelText: '취소',
        cancelStyle: const TextStyle(color: AppColors.mainBlue2),
        hourLabel: '시',
        minuteLabel: '분',
        accentColor: AppColors.mainBlue2));
  }

  void _searchPlace() async {
    final result = await Nav.push(SearchNaver());
    if (result != null) {
      placeController.text = result
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'");
    }
  }

  bool get isFilled =>
      dateController.text.isNotEmpty &&
      timeController.text.isNotEmpty &&
      placeController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    dateController.addListener(updateState);
    timeController.addListener(updateState);
    placeController.addListener(updateState);
    dateNode.addListener(updateState);
    timeNode.addListener(updateState);
    placeNode.addListener(updateState);
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return
        // MaterialApp(
        // debugShowCheckedModeBanner: false,
        // home: SafeArea(
        //   child:
        Scaffold(
      appBar: AppBar(
        title: '약속 생성'.text.bold.black.make(),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // const BasicAppBar(
          //     text: '약속 생성', isProgressBar: true, percentage: 100),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            percent: 100 / 100,
            lineHeight: 3,
            backgroundColor: const Color(0xffCACFD8),
            progressColor: AppColors.mainBlue2,
            width: MediaQuery.of(context).size.width,
          ),
          _buildTextField('날짜', dateController, dateNode, timeNode),
          _buildTextField('시간', timeController, timeNode, placeNode),
          _buildTextField('장소', placeController, placeNode, null),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: double.infinity,
        height: 48,
        margin: const EdgeInsets.all(14),
        child: FilledButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CheckedModal();
                  });
            },
            style: FilledButton.styleFrom(
                backgroundColor: isFilled ? AppColors.mainBlue : Colors.grey),
            child: Text(isFilled ? '다음' : '건너뛰기')),
      ),
    );
    //   ,),
    // );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      FocusNode node, FocusNode? nextNode) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          alignment: Alignment.topLeft,
          child: Text(label,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: controller.text.isEmpty && !node.hasFocus
                  ? Colors.grey
                  : AppColors.mainBlue2,
            ),
          ),
          child: TextField(
            showCursor: label == '장소',
            focusNode: node,
            controller: controller,
            decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
            onTap: () async {
              if (label == '날짜') await _selectDate();
              if (label == '시간') await _selectTime();
              if (label == '장소') _searchPlace();
            },
          ),
        ),
      ],
    );
  }
}
