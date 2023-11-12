package com.wanyviny.calendar.global.kafka.service;

import com.wanyviny.calendar.global.kafka.dto.CalendarConsumerDto;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class KafkaProducerService {
    private static final String TOPIC = "from-mysql-userId";
    private final KafkaTemplate<String, CalendarConsumerDto> kafkaTemplate;

    public void sendMessage(CalendarConsumerDto dto) {
        System.out.println("dto = " + dto.getContext());

        kafkaTemplate.send(TOPIC, dto);
    }
}
