package com.wanyviny.promise.domain.alarm.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.wanyviny.promise.domain.alarm.ALARM_TYPE;
import com.wanyviny.promise.domain.user.entity.User;
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
    @Builder.Default
    private Boolean alarmState = false;

    @Column(name = "ALARM_DATE")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Builder.Default
    private Date alarmDate = new Date();

    @Column(name = "ALARM_TYPE")
    private ALARM_TYPE alarmType;

    @Column(name = "ROOM_ID")
    private Long roomId;

}
