package com.wanyviny.calendar.domain.calendar.service;

import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;

import java.util.List;

public interface CalendarService {
    void postSchdule(Long id, CalendarDto.setSchedule schedule);

    List<CalendarDto.getSchedule> getMySchedule(Long id);

    CalendarDto.getSchedule getDetailSchedule(Long calendarId);
}
