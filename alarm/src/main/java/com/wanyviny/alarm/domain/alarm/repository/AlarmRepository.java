package com.wanyviny.alarm.domain.alarm.repository;

import com.wanyviny.alarm.domain.alarm.entity.Alarm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AlarmRepository extends JpaRepository<Alarm, Long> {
    List<Alarm> findByUserId(Long userId);

    void deleteByAlarmId(Long alarmId);
}
