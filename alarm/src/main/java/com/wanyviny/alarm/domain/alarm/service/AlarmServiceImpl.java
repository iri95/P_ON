package com.wanyviny.alarm.domain.alarm.service;

import com.wanyviny.alarm.domain.alarm.dto.AlarmDto;
import com.wanyviny.alarm.domain.alarm.entity.Alarm;
import com.wanyviny.alarm.domain.alarm.repository.AlarmRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AlarmServiceImpl implements AlarmService{

    private final AlarmRepository alarmRepository;

    @Override
    public List<AlarmDto.getAlarmDto> getAlarm(Long userId) {
        List<Alarm> alarmList = alarmRepository.findByUserId(userId);

        return alarmList.stream()
                .map(Alarm::entityToDto)
                .sorted()
                .toList();
    }
}
