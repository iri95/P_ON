package com.wanyviny.calendar.domain.calendar.service;

import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;

public interface CalendarService {
    void postSchdule(Long id, CalendarDto.setSchedule schedule);
}
