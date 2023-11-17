package com.wanyviny.promise.domain.calendar.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
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

}

