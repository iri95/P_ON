package com.wanyviny.user.domain.alarm;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum ALARM_TYPE {
    FRIEND("TYPE_FRIEND")                   // {상대회원닉네임}님이 당신을 팔로우했습니다.
    ,INVITE("TYPE_INVITE")                  // {약속생성자}님께서 {약속방이름}에 초대했습니다.
    ,CREATE_POLL("TYPE_CREATE_POLL")        // {약속방이름}에 {투표종류} 투표가 시작되었습니다. \n투표에 참여하세요
    ,END_POLL("TYPE_END_POLL")              // {약속방이름}에 {투표종류} 투표가 종료되었습니다. \n투표 결과를 확인해보세요
    ,AHEAD_PROMISE("TYPE_AHEAD_PROMISE")    // {약속방이름} 까지 ?시간 남았습니다. \n서둘러 준비하세요!
    ,END_PROMISE("TYPE_END_PROMISE");       // {약속방이름}이 종료되었습니다. \n함께한 시간을 추억해보세요

    private final String key;
}
