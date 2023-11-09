package com.wanyviny.alarm.domain.alarm.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.wanyviny.alarm.domain.alarm.ALARM_TYPE;
import com.wanyviny.alarm.domain.alarm.entity.Alarm;
import com.wanyviny.alarm.domain.user.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Date;

public class AlarmDto {

    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    @Getter
    public static class getAlarmDto implements Comparable<getAlarmDto> {
        private Long alarmId;
        private String alarmMessage;
        private Boolean alarmState;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date alarmDate;
        private ALARM_TYPE alarmType;

        @Override
        public int compareTo(getAlarmDto o) {
            if (!this.alarmState && o.alarmState) {
                return -1;
            }

            if (this.alarmState && !o.alarmState) {
                return 1;
            }

            if (this.alarmDate.before(o.getAlarmDate())) return 1;
            if (this.alarmDate.after(o.alarmDate)) return -1;
            return 0;
        }
    }

    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    @Getter
    public static class setAlarmDto {
        private String alarmMessage;
        private Boolean alarmState;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date alarmDate;
        private ALARM_TYPE alarmType;

        public Alarm dtoToEntity(User user){
            return Alarm.builder()
                    .user(user)
                    .alarmMessage(this.alarmMessage)
                    .alarmState(this.alarmState)
                    .alarmDate(this.alarmDate)
                    .alarmType(this.alarmType)
                    .build();
        }
    }

}
