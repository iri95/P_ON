package com.wanyviny.calendar.global.kafka.service;

import com.wanyviny.calendar.global.kafka.dto.KafkaCalendarDto;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class KafkaProducerService {
    private static final String TOPIC = "from-mysql-json";
    private final KafkaTemplate<String, KafkaCalendarDto> kafkaTemplate;

    public void sendCalendar(KafkaCalendarDto dto) {
        System.out.println("dto = " + dto.getUserId());
        kafkaTemplate.send(TOPIC, dto);
    }
}
