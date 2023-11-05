package com.wanyviny.calendar.domain.calendar.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.wanyviny.calendar.domain.calendar.entity.Calendar;
import com.wanyviny.calendar.domain.user.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;


public class CalendarDto {

    @Builder
    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class getSchedule {
        private Long calendarId;
        private String title;
        private String content;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date startDate;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date endDate;
        private String place;
    }

    @Builder
    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class setSchedule implements Serializable {
        private String title;
        private String content;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date startDate;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date endDate;
        private String place;

        public Calendar dtoToEntity(User user) {
            return Calendar.builder()
                    .userId(user)
                    .title(title)
                    .content(content)
                    .startDate(startDate)
                    .endDate(endDate)
                    .place(place)
                    .build();
        }
    }

    @Builder
    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class promiseScheduleDto {
        private String nickName;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date startDate;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date endDate;
    }

}
