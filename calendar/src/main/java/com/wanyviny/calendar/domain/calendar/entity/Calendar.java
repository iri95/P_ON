package com.wanyviny.calendar.domain.calendar.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.wanyviny.calendar.domain.CALENDAR_TYPE;
import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;
import com.wanyviny.calendar.domain.calendar.dto.RedisCalendarDto;
import com.wanyviny.calendar.domain.user.entity.User;
import com.wanyviny.calendar.global.kafka.dto.KafkaCalendarDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.text.SimpleDateFormat;
import java.util.Date;

@Entity
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Calendar {
    @Id
    @Column(name = "CALENDAR_ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "USER_ID")
    private User userId;

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

    @Column(name = "CALENDAR_TYPE")
    @Builder.Default
    private CALENDAR_TYPE type = CALENDAR_TYPE.SCHEDULE;

    public void update(CalendarDto.setSchedule schedule) {
        this.title = schedule.getTitle();
        this.content = schedule.getContent();
        this.startDate = schedule.getStartDate();
        this.endDate = schedule.getEndDate();
        this.place = schedule.getPlace();
    }

    public CalendarDto.getSchedule entityToDto(){
        return CalendarDto.getSchedule.builder()
                .calendarId(this.id)
                .title(this.title)
                .content(this.content)
                .startDate(this.startDate)
                .endDate(this.endDate)
                .place(this.place)
                .type(this.type)
                .build();
    }

    public CalendarDto.promiseScheduleDto entityToPromiseDto() {
        return CalendarDto.promiseScheduleDto.builder()
                .nickName(this.userId.getNickname())
                .startDate(this.startDate)
                .endDate(this.endDate)
                .build();
    }

    public KafkaCalendarDto entityToKafka(){
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        String startDate = format.format(getStartDate());
        String endDate = format.format(getEndDate());

        return KafkaCalendarDto.builder()
                .userId(userId.getId())
                .cal(KafkaCalendarDto.Cal.builder()
                        .calendar_title(title)
                        .calendar_place(place)
                        .calendar_start_date(startDate)
                        .calendar_end_date(endDate)
                        .build())
                .build();
    }
}
