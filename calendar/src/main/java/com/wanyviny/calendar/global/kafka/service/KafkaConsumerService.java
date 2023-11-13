package com.wanyviny.calendar.global.kafka.service;

import com.wanyviny.calendar.domain.calendar.service.CalendarService;
import com.wanyviny.calendar.domain.user.repository.UserRepository;
import com.wanyviny.calendar.global.kafka.dto.KafkaCalendarDto;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import java.text.ParseException;

@Service
@RequiredArgsConstructor
public class KafkaConsumerService {

    private final CalendarService calendarService;

    @KafkaListener(topics = "to-mysql-json", groupId = "postCalendar", containerFactory = "kafkaListener")
    public void consume(KafkaCalendarDto dto) throws ParseException {
        calendarService.postSchedule(dto.getUserId(), dto.kafkaToSet());
    }
}