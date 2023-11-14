import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleProvider = StateNotifierProvider<ScheduleNotifier, Schedule>(
    (ref) => ScheduleNotifier());

class Schedule {
  String? schedule_title;
  String? schedule_content;
  DateTime? schedule_start_date;
  DateTime? schedule_end_date;
  String? schedule_start_time;
  String? schedule_end_time;
  bool? schedule_all_time = false;
  String? schedule_location;
  NLatLng? schedule_location_code;

  Schedule({
    this.schedule_title,
    this.schedule_content,
    this.schedule_start_date,
    this.schedule_end_date,
    this.schedule_start_time,
    this.schedule_end_time,
    this.schedule_all_time,
    this.schedule_location,
    this.schedule_location_code,
  });

  Schedule copyWith({
    String? schedule_title,
    String? schedule_content,
    DateTime? schedule_start_date,
    DateTime? schedule_end_date,
    String? schedule_start_time,
    String? schedule_end_time,
    String? schedule_location,
    NLatLng? schedule_location_code,
    bool? schedule_all_time,
  }) {
    return Schedule(
      schedule_title: schedule_title ?? this.schedule_title,
      schedule_content: schedule_content ?? this.schedule_content,
      schedule_start_date: schedule_start_date ?? this.schedule_start_date,
      schedule_end_date: schedule_end_date ?? this.schedule_end_date,
      schedule_start_time: schedule_start_time ?? this.schedule_start_time,
      schedule_end_time: schedule_end_time ?? this.schedule_end_time,
      schedule_location: schedule_location ?? this.schedule_location,
      schedule_location_code:
          schedule_location_code ?? this.schedule_location_code,
      schedule_all_time: schedule_all_time ?? this.schedule_all_time,
    );
  }
}

class ScheduleNotifier extends StateNotifier<Schedule> {
  ScheduleNotifier() : super(Schedule());

  void setScheduleTitle(String schedule_title) {
    print('setTitle 들어옴');
    state = state.copyWith(
        schedule_title: schedule_title.isEmpty ? null : schedule_title);
  }

  void setScheduleContent(String schedule_content) {
    print('setContent 들어옴');
    state = state.copyWith(
        schedule_content: schedule_content.isEmpty ? null : schedule_content);
  }

  void setScheduleStartDate(DateTime schedule_start_date) {
    print('StartDate 변경전 : ${state.schedule_start_date}');
    state = state.copyWith(schedule_start_date: schedule_start_date);
    print('StartDate 변경후 : ${state.schedule_start_date}');
  }

  void setScheduleEndDate(DateTime schedule_end_date) {
    state = state.copyWith(schedule_end_date: schedule_end_date);
    print('EndDate : ${state.schedule_end_date}');
  }

  void setScheduleStartTime(String schedule_start_time) {
    print('StartTime 변경전 : ${state.schedule_start_time}');
    state = state.copyWith(schedule_start_time: schedule_start_time);
    print('StartTime 변경후 : ${state.schedule_start_time}');
  }

  void setScheduleEndTime(String schedule_end_time) {
    state = state.copyWith(schedule_end_time: schedule_end_time);
  }

  void setScheduleAllTime(bool schedule_all_time) {
    print("토글 상태 변경 전: ${state.schedule_all_time}");
    // state.schedule_all_time이 null인 경우 false로 간주합니다.
    bool currentAllTime = state.schedule_all_time ?? false;
    // 현재 상태의 반대값을 설정합니다.
    state = state.copyWith(schedule_all_time: !currentAllTime);
    print("토글 상태 변경 후: ${state.schedule_all_time}");
  }

  void setScheduleLocation(
      String schedule_location, NLatLng schedule_location_code) {
    print('=========');
    print('=========');
    print('=========');
    print('=========');
      print('지도 들어왔냐');
    state = state.copyWith(
        schedule_location: schedule_location,
        schedule_location_code: schedule_location_code);
  }

  void reset() {
    print('reset된다!!!!');
    state = Schedule(
      schedule_start_date: DateTime.now(),
      schedule_end_date: DateTime.now(),
    );
  }
}
