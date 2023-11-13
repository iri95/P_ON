package com.wanyviny.calendar.global.kafka.service;

import com.wanyviny.calendar.domain.calendar.entity.Calendar;
import com.wanyviny.calendar.domain.calendar.repository.CalendarRepository;
import com.wanyviny.calendar.global.kafka.dto.KafkaCalendarDto;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class KafkaProducerService {
    private static final String TOPIC = "from-mysql-json";
    private final KafkaTemplate<String, KafkaCalendarDto> kafkaTemplate;
    private final CalendarRepository calendarRepository;

    public void sendCalendar(KafkaCalendarDto dto) {
        System.out.println("dto = " + dto.getUserId());
        kafkaTemplate.send(TOPIC, dto);
    }

    @PostConstruct
    public void initCalendar() {
        List<Calendar> calendarList = calendarRepository.findAll();
        calendarList.stream()
                .map(Calendar::entityToKafka)
                .toList()
                .forEach(dto -> kafkaTemplate.send(TOPIC, dto));
    }
}
