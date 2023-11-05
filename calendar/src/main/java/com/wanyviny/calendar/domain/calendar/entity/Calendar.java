package com.wanyviny.calendar.domain.calendar.entity;

import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;
import com.wanyviny.calendar.domain.user.entity.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

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
    private Date startDate;

    @Column(name = "CALENDAR_END_DATE")
    private Date endDate;

    @Column(name = "CALENDAR_PLACE")
    private String place;

    public CalendarDto.getSchedule entityToDto(){
        return CalendarDto.getSchedule.builder()
                .calendarId(this.getId())
                .title(this.title)
                .content(this.content)
                .startDate(this.startDate)
                .endDate(this.endDate)
                .place(this.place)
                .build();
    }

    public void update(CalendarDto.setSchedule schedule) {
        this.title = schedule.getTitle();
        this.content = schedule.getContent();
        this.startDate = schedule.getStartDate();
        this.endDate = schedule.getEndDate();
        this.place = schedule.getPlace();
    }

    public CalendarDto.promiseScheduleDto entityToPromiseDto() {
        return CalendarDto.promiseScheduleDto.builder()
                .nickName(this.userId.getNickname())
                .startDate(this.startDate)
                .endDate(this.endDate)
                .build();
    }
}
