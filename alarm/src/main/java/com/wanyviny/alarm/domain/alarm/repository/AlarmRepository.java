package com.wanyviny.alarm.domain.alarm.repository;

import com.wanyviny.alarm.domain.alarm.ALARM_TYPE;
import com.wanyviny.alarm.domain.alarm.entity.Alarm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface AlarmRepository extends JpaRepository<Alarm, Long> {
    List<Alarm> findByUserId_Id(Long userId);

    List<Alarm> findByUserIdAndAlarmType(Long userId, ALARM_TYPE alarmType);

    void deleteByAlarmId(Long alarmId);

    @Transactional
    @Modifying
    @Query("UPDATE Alarm a set a.alarmState = true where a.alarmId = :alarmId")
    void updateStateByAlarmId(Long alarmId);

    @Transactional
    @Modifying
    @Query("UPDATE Alarm a set a.alarmState = true where a.user.id = :userId")
    void updateStateAllByUserId(Long userId);

    void deleteByUserId(Long userId);
}
