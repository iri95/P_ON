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

    public static CalendarDto.getSchedule entityToDtoList(Calendar calendar){
        return CalendarDto.getSchedule.builder()
                .calendarId(calendar.getId())
                .title(calendar.title)
                .content(calendar.content)
                .startDate(calendar.startDate)
                .endDate(calendar.endDate)
                .place(calendar.place)
                .build();
    }
}
