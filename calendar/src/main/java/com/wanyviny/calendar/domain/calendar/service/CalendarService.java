package com.wanyviny.calendar.domain.calendar.service;

import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;

import java.util.List;

public interface CalendarService {
    void postSchdule(Long id, CalendarDto.setSchedule schedule);

    List<CalendarDto.getSchedule> getMySchedule(Long id);

    CalendarDto.getSchedule getDetailSchedule(Long id, Long calendarId);

    List<CalendarDto.getSchedule> getUserSchedule(Long id, Long userId);

    void updateSchedule(Long id, Long calendarId, CalendarDto.setSchedule schedule);

    void deleteSchedule(Long id, Long calendarId);

    List<CalendarDto.promiseScheduleDto> getPromiseSchedule(List<Long> userIdList);
}
