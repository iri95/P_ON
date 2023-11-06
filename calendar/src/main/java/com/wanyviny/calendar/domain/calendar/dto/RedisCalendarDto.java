package com.wanyviny.calendar.domain.calendar.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
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
    @Column(name = "CALENDAR_TITLE")
    private String title;

    @Column(name = "CALENDAR_CONTENT")
    private String content;

    @Column(name = "CALENDAR_START_DATE")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startDate;

    @Column(name = "CALENDAR_END_DATE")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endDate;

    @Column(name = "CALENDAR_PLACE")
    private String place;

}
