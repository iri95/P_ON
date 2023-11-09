package com.wanyviny.alarm.domain.alarm.service;

import com.wanyviny.alarm.domain.alarm.dto.AlarmDto;

import java.util.List;

public interface AlarmService {
    List<AlarmDto.getAlarmDto> getAlarm(Long userId);
}
