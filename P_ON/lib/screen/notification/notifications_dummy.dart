import 'package:p_on/common/dart/extension/num_duration_extension.dart';

import 'vo/vo_notification.dart';

final notificationDummies = <TtossNotification>[
  TtossNotification(
    '약속방 초대',
    '{약속생성자}님께서 {약속방이름}에 초대했습니다.',
    DateTime.now().subtract(27.minutes),
  ),
  TtossNotification(
    '투표 생성',
    '{약속방이름}에 {투표종류} 투표가 시작되었습니다. \n투표에 참여하세요',
    DateTime.now().subtract(1.hours),
  ),
  TtossNotification(
    '투표 마감',
    '{약속방이름}에 {투표종류} 투표가 종료되었습니다. \n투표 결과를 확인해보세요',
    DateTime.now().subtract(1.hours),
    isRead: true,
  ),
  TtossNotification(
    '약속 임박',
    '{약속방이름} 까지 ?시간 남았습니다. \n서둘러 준비하세요!',
    DateTime.now().subtract(8.hours),
    isRead: true,
  ),
  TtossNotification(
    '약속 종료',
    '{약속방이름}이 종료되었습니다. \n함께한 시간을 추억해보세요',
    DateTime.now().subtract(8.hours),
    isRead: true,
  ),
  TtossNotification(
    '친구',
    '{상대회원닉네임}님이 당신을 팔로우했습니다.',
    DateTime.now().subtract(8.hours),
    isRead: true,
  ),
];
