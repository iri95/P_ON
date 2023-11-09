package com.wanyviny.alarm.domain.alarm.service;

import com.wanyviny.alarm.domain.alarm.ALARM_TYPE;
import com.wanyviny.alarm.domain.alarm.dto.AlarmDto;
import com.wanyviny.alarm.domain.user.entity.User;

import java.util.List;

public interface AlarmService {
    List<AlarmDto.getAlarmDto> getAlarm(Long userId);

    List<AlarmDto.getAlarmDto> getAlarmByType(Long userId, ALARM_TYPE alarmType);

    void postAlarm(User user, AlarmDto.setAlarmDto alarmDto);

    void deleteAlarm(Long userId, Long alarmId);

    int getAlarmCount(Long userId);

    Long getAlarmCountNonRead(Long userId);

    void putAlarmState(Long alarmId);

    void putAlarmStateAll(Long userId);


}
