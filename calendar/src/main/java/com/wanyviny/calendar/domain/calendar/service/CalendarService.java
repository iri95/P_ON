package com.wanyviny.calendar.domain.calendar.service;

import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;
import com.wanyviny.calendar.domain.calendar.dto.RedisCalendarDto;

import java.util.List;
import java.util.Map;

public interface CalendarService {
    void postSchdule(Long id, CalendarDto.setSchedule schedule);

    Map<String, RedisCalendarDto.getSchedule> getMySchedule(Long id);

    CalendarDto.getSchedule getDetailSchedule(Long id, Long calendarId);

    List<CalendarDto.promiseScheduleDto> getUserSchedule(Long id, Long userId);

    void updateSchedule(Long id, Long calendarId, CalendarDto.setSchedule schedule);

    void deleteSchedule(Long id, Long calendarId);

    List<CalendarDto.promiseScheduleDto> getPromiseSchedule(List<Long> userIdList);

    void deleteScheduleList(Long id, List<Long> deleteList);
}
