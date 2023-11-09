package com.wanyviny.alarm.domain.alarm;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum ALARM_TYPE {
    FRIEND("TYPE_FRIEND")
    ,INVITE("TYPE_INVITE")
    ,CREATE_POLL("TYPE_CREATE_POLL")
    ,END_POLL("TYPE_END_POLL")
    ,AHEAD_PROMISE("TYPE_AHEAD_PROMISE")
    ,END_PROMISE("TYPE_END_PROMISE");

    private final String key;
}
