import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final promiseProvider = StateNotifierProvider<PromiseNotifier, Promise>((ref) => PromiseNotifier());

class Friends {
  final String id;
  final String userImage;
  final String userName;

  Friends({
    required this.id,
    required this.userImage,
    required this.userName,
});
}

class Promise {
  String? promise_title;
  List<Friends>? selected_friends;
  DateTime? promise_date;
  TimeOfDay? promise_time;
  String? promise_location;
  NLatLng? promise_location_code;

  Promise(
      {this.promise_title,
      this.selected_friends,
      this.promise_date,
      this.promise_time,
      this.promise_location,
      this.promise_location_code,
      });
}

class PromiseNotifier extends StateNotifier<Promise> {
  PromiseNotifier() : super(Promise());

  void setPromiseTitle(String promise_title) {
    state = Promise(
        promise_title: promise_title.isEmpty ? null : promise_title,
        selected_friends: state.selected_friends,
        promise_date: state.promise_date,
        promise_time: state.promise_time,
        promise_location: state.promise_location,
        promise_location_code: state.promise_location_code
    );
  }

  void addFriends(Friends friends) {
    state = Promise(
        promise_title: state.promise_title,
        selected_friends: List.from(state.selected_friends ?? [])..add(friends),
        promise_date: state.promise_date,
        promise_time: state.promise_time,
        promise_location: state.promise_location,
        promise_location_code: state.promise_location_code
    );
  }

  void removeFriends(String friendId) {
    state = Promise(
      promise_title: state.promise_title,
        selected_friends: state.selected_friends?.where((friend) => friend.id != friendId).toList(),
        promise_date: state.promise_date,
        promise_time: state.promise_time,
        promise_location: state.promise_location,
        promise_location_code: state.promise_location_code
    );
  }

  void setPromiseDate(DateTime promise_date) {
    state = Promise(
        promise_title: state.promise_title,
        selected_friends: state.selected_friends,
        promise_date: promise_date,
        promise_time: state.promise_time,
        promise_location: state.promise_location,
        promise_location_code: state.promise_location_code
    );
  }

  void setPromiseTime(TimeOfDay promise_time) {
    state = Promise(
        promise_title: state.promise_title,
        selected_friends: state.selected_friends,
        promise_date: state.promise_date,
        promise_time: promise_time,
        promise_location: state.promise_location,
        promise_location_code: state.promise_location_code
    );
  }

  void setPromiseLocation(String promise_location, NLatLng promise_location_code) {
    state = Promise(
        promise_title: state.promise_title,
        selected_friends: state.selected_friends,
        promise_date: state.promise_date,
        promise_time: state.promise_time,
        promise_location: promise_location,
        promise_location_code: promise_location_code
    );
  }

  // db에 데이터 저장하고 나중에 다시 약속 생성하기전 미리 초기화
  void reset() {
    state = Promise();
  }
}

