package com.wanyviny.alarm.domain.alarm.service;

import com.wanyviny.alarm.domain.alarm.ALARM_TYPE;
import com.wanyviny.alarm.domain.alarm.dto.AlarmDto;
import com.wanyviny.alarm.domain.alarm.entity.Alarm;
import com.wanyviny.alarm.domain.alarm.repository.AlarmRepository;
import com.wanyviny.alarm.domain.user.entity.User;
import com.wanyviny.alarm.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AlarmServiceImpl implements AlarmService{

    private final AlarmRepository alarmRepository;
    private final UserRepository userRepository;

    @Override
    public List<AlarmDto.getAlarmDto> getAlarm(Long userId) {
        List<Alarm> alarmList = alarmRepository.findByUserId_Id(userId);

        return alarmList.stream()
                .map(Alarm::entityToDto)
                .sorted()
                .toList();
    }

    @Override
    public List<AlarmDto.getAlarmDto> getAlarmByType(Long userId, ALARM_TYPE alarmType) {
        List<Alarm> alarmList = alarmRepository.findByUserIdAndAlarmType(userId, alarmType);

        return alarmList.stream()
                .map(alarm -> {
                    if(alarm.getAlarmType() == ALARM_TYPE.FRIEND){
                        return alarm.entityToDto();
                    }else {
                        return alarm.entityToPromiseDto();
                    }
                })
                .sorted()
                .toList();
    }

    @Override
    public void postAlarm(User user, AlarmDto.setAlarmDto alarmDto) {
        if(alarmDto.getAlarmType() == ALARM_TYPE.FRIEND) {
            alarmRepository.save(alarmDto.dtoToEntity(user));
        }else{
            alarmRepository.save(alarmDto.dtoToPromiseEntity(user));
        }
    }

    @Override
    public int getAlarmCount(Long userId) {
        return alarmRepository.findByUserId_Id(userId).size();
    }

    @Override
    public Long getAlarmCountNonRead(Long userId) {
        return alarmRepository.findByUserId_Id(userId).stream()
                .filter(alarm -> !alarm.getAlarmState())
                .count();
    }

    @Override
    public void putAlarmState(Long alarmId) {
        alarmRepository.updateStateByAlarmId(alarmId);
    }

    @Override
    public void putAlarmStateAll(Long userId) {
        alarmRepository.updateStateAllByUserId(userId);
    }

    @Override
    public void deleteAlarm(Long alarmId) {
        alarmRepository.deleteByAlarmId(alarmId);
    }

    @Override
    public void deleteAlarmRead(Long userId) {
        alarmRepository.deleteByUserIdAndAlarmStateTrue(userId);
    }

    @Override
    public void deleteAlarmAll(Long userId) {
        alarmRepository.deleteByUserId(userId);
    }
}
