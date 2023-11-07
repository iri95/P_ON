import 'package:flutter_riverpod/flutter_riverpod.dart';

final voteProvider = StateNotifierProvider<VoteNotifier, VoteDate>((ref) => VoteNotifier());
final deadLineProvider = StateNotifierProvider<DeadLineNotifier, Deadline>((ref) => DeadLineNotifier());

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
}

class Deadline {
  String? dead_date;
  String? dead_time;

  Deadline({
    this.dead_date,
    this.dead_time
  });
}

class DeadLineNotifier extends StateNotifier<Deadline> {
  DeadLineNotifier() : super(Deadline());

  void setDeadDate(String date) {
    state = Deadline(
      dead_date: date,
      dead_time: state.dead_time
    );
  }

  void setDeadTime(String time) {
    state = Deadline(
      dead_date: state.dead_date,
      dead_time: time
    );
  }
}