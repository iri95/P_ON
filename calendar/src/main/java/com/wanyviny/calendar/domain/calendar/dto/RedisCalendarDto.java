package com.wanyviny.calendar.domain.calendar.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
public class RedisCalendarDto {
    private Long id;
    private String content;
    private String title;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startDate;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endDate;
    private String place;

    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Getter
    public static class getSchedule{
        private Long id;
        private String title;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date startDate;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date endDate;
    }

    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Getter
    public static class getDetailSchedule {
        private Long id;
        private String title;
        private String content;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date startDate;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date endDate;
        private String place;
    }

    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Getter
    public static class getScheduleList{
        private String nickName;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date startDate;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date endDate;
    }

    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Getter
    public static class setSchedule{
        private String title;
        private String content;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date startDate;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private Date endDate;
        private String place;
    }

}
