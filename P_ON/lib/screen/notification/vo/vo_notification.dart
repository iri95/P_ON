class TtossNotification {
  final String type;
  final String description;
  final DateTime time;
  bool isRead;

  TtossNotification(
    this.type,
    this.description,
    this.time, {
    this.isRead = false,
  });
}

enum NotificationType {
  friend,
  invite,
  create_poll,
  end_poll,
  ahead_promise,
  end_promise
}

extension NotificationTypeExtension on NotificationType {
  String get typeInKorean {
    switch (this) {
      case NotificationType.friend:
        return '친구';
      case NotificationType.invite:
        return '약속방 초대';
      case NotificationType.create_poll:
        return '투표 생성';
      case NotificationType.end_poll:
        return '투표 마감';
      case NotificationType.ahead_promise:
        return '약속 임박';
      case NotificationType.end_promise:
        return '약속 종료';
      default:
        return '';
    }
  }
}

class MyNotification {
  final int id;
  final String type;
  final String description;
  final DateTime time;
  bool isRead;

  MyNotification(
    this.id,
    NotificationType type,
    this.description,
    this.time, {
    this.isRead = false,
  }) : type = type.typeInKorean;

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    return MyNotification(
      json['alarmId'] as int,
      notificationTypeFromString(json['alarmType'] as String),
      json['alarmMessage'] as String,
      DateTime.parse(json['alarmDate'] as String),
      isRead: json['alarmState'] as bool,
    );
  }
}

NotificationType notificationTypeFromString(String type) {
  switch (type) {
    case 'FRIEND':
      return NotificationType.friend;
    case 'INVITE':
      return NotificationType.invite;
    case 'CREATE_POLL':
      return NotificationType.create_poll;
    case 'END_POLL':
      return NotificationType.end_poll;
    case 'AHEAD_PROMISE':
      return NotificationType.ahead_promise;
    case 'END_PROMISE':
      return NotificationType.end_promise;
    default:
      throw ArgumentError('Unknown notification type: $type');
  }
}
