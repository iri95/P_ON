package com.wanyviny.alarm.domain.alarm.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.wanyviny.alarm.domain.alarm.ALARM_TYPE;
import com.wanyviny.alarm.domain.alarm.dto.AlarmDto;
import com.wanyviny.alarm.domain.user.entity.User;
import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import java.util.Date;

@Entity
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "ALARMS")
public class Alarm {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ALARM_ID")
    private Long alarmId;

    @ManyToOne
    @JoinColumn(name = "USER_ID")
    private User user;

    @Column(name = "ALARM_MESSAGE")
    private String alarmMessage;

    @Column(name = "ALARM_STATE")
    private Boolean alarmState;

    @Column(name = "ALARM_DATE")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date alarmDate;

    @Column(name = "ALARM_TYPE")
    private ALARM_TYPE alarmType;

    @Column(name = "ROOM_ID")
    private Long roomId;

    public AlarmDto.getAlarmDto entityToDto() {
        return AlarmDto.getAlarmDto.builder()
                .alarmId(this.alarmId)
                .alarmMessage(this.alarmMessage)
                .alarmDate(this.alarmDate)
                .alarmState(this.alarmState)
                .alarmType(this.alarmType)
                .build();
    }

    public AlarmDto.getAlarmDto entityToPromiseDto() {
        return AlarmDto.getAlarmDto.builder()
                .alarmId(this.alarmId)
                .alarmMessage(this.alarmMessage)
                .alarmDate(this.alarmDate)
                .alarmState(this.alarmState)
                .alarmType(this.alarmType)
                .roomId(this.roomId)
                .build();
    }
}
