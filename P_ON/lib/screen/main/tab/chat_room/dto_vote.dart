import 'package:flutter_riverpod/flutter_riverpod.dart';

final voteProvider = StateNotifierProvider<VoteNotifier, VoteDate>((ref) => VoteNotifier());
final voteInfoProvider = StateNotifierProvider<VoteInfoNotifier, VoteInfo>((ref) => VoteInfoNotifier());

class VoteDate {
  List<String>? vote_date;
  List<String>? vote_time;
  List<Map<String, String>>? vote_location;

  VoteDate({
  this.vote_date = const [],
  this.vote_time = const [],
  this.vote_location = const []
  });
}

class VoteNotifier extends StateNotifier<VoteDate> {
  VoteNotifier() : super(VoteDate());

  void setState(VoteDate newVoteDate) {
    state = newVoteDate;
  }

  void addVoteDate(String date) {
    state = VoteDate(
      vote_date: List.from(state.vote_date ?? [])..add(date),
      vote_time: state.vote_time,
      vote_location: state.vote_location
    );
  }

  void removeVoteDate(int index) {
    state = VoteDate(
      vote_date: List.from(state.vote_date ?? [])..removeAt(index),
      vote_time: state.vote_time,
      vote_location: state.vote_location,
    );
  }

  void updateVoteDate(int index, String newDate) {
    state = VoteDate(
        vote_date: List.from(state.vote_date ?? [])..[index] = newDate,
        vote_time: state.vote_time,
        vote_location: state.vote_location
    );
  }

  void addVoteTime(String time) {
    state = VoteDate(
      vote_date: state.vote_date,
      vote_time: List.from(state.vote_time ?? [])..add(time),
      vote_location: state.vote_location
    );
  }

  void removeVoteTime(int index) {
    state = VoteDate(
      vote_date: state.vote_date,
      vote_time: List.from(state.vote_time ?? [])..removeAt(index),
      vote_location: state.vote_location,
    );
  }

  void updateVoteTime(int index, String newDate) {
    state = VoteDate(
        vote_date: state.vote_date,
        vote_time: List.from(state.vote_time ?? [])..[index] = newDate,
        vote_location: state.vote_location
    );
  }

  void addVoteLocation(String location, String lat, String lng) {
    state = VoteDate(
      vote_date: state.vote_date,
      vote_time: state.vote_time,
      vote_location: List.from(state.vote_location ?? [])..add({
        'location' : location,
        'lat' : lat,
        'lng' : lng
      })
    );
  }

  void removeVoteLocation(int index) {
    state = VoteDate(
      vote_date: state.vote_date,
      vote_time: state.vote_time,
        vote_location: List.from(state.vote_location ?? [])..removeAt(index)
    );
  }

  void updateVoteLocation(int index, String newLocation, String newLat, String newLng) {
    state = VoteDate(
      vote_date: state.vote_date,
      vote_time: state.vote_time,
      vote_location: List.from(state.vote_location ?? [])..[index] = {
        'location' : newLocation,
        'lat' : newLat,
        'lng' : newLng
      },
    );
  }

}

class VoteInfo {
  int? create_user;
  bool? is_anonymous;
  bool? is_multiple_choice;
  String? dead_date;
  String? dead_time;

  VoteInfo(
      {
        this.create_user,
        this.is_anonymous,
        this.is_multiple_choice,
        this.dead_date,
        this.dead_time,
      });
}

class VoteInfoNotifier extends StateNotifier<VoteInfo> {
  VoteInfoNotifier() : super(VoteInfo());

  void setVoteInfo(VoteInfo newVoteInfo) {
    state = newVoteInfo;
  }

  void setCreateUser(int userId) {
    state = VoteInfo(
      create_user: userId,
      is_anonymous: state.is_anonymous,
      is_multiple_choice: state.is_multiple_choice,
      dead_date: state.dead_date,
      dead_time: state.dead_time
    );
  }

  void setAnonymous(bool anonymous) {
    state = VoteInfo(
      create_user: state.create_user,
      is_anonymous: anonymous,
      is_multiple_choice: state.is_multiple_choice,
      dead_date: state.dead_date,
      dead_time: state.dead_time
    );
  }

  void setMultiple(bool multiple) {
    state = VoteInfo(
      create_user: state.create_user,
      is_anonymous: state.is_anonymous,
      is_multiple_choice: multiple,
      dead_date: state.dead_date,
      dead_time: state.dead_time
    );
  }

  void setDeadDate(String deaddate) {
    state = VoteInfo(
      create_user: state.create_user,
      is_anonymous: state.is_anonymous,
      is_multiple_choice: state.is_multiple_choice,
      dead_date: deaddate,
      dead_time: state.dead_time
    );
  }

  void setDeadTime(String deadtime) {
    state = VoteInfo(
      create_user: state.create_user,
      is_anonymous: state.is_anonymous,
      is_multiple_choice: state.is_multiple_choice,
      dead_date: state.dead_date,
      dead_time: deadtime
    );
  }
}