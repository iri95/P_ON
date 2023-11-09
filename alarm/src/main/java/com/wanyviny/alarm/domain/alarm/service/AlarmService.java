package com.wanyviny.alarm.domain.alarm.service;

import com.wanyviny.alarm.domain.alarm.dto.AlarmDto;
import com.wanyviny.alarm.domain.user.entity.User;

import java.util.List;

public interface AlarmService {
    List<AlarmDto.getAlarmDto> getAlarm(Long userId);

    void postAlarm(User user, AlarmDto.setAlarmDto alarmDto);

    void deleteAlarm(Long userId, Long alarmId);
}
