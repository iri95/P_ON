package com.wanyviny.calendar.global.kafka.controller;

import com.wanyviny.calendar.global.kafka.dto.CalendarConsumerDto;
import com.wanyviny.calendar.global.kafka.service.KafkaProducerService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class KafkaController {
    private final KafkaProducerService producerService;

    @PostMapping("/kafka")
    public String sendMessage(@RequestBody CalendarConsumerDto dto) {
        System.out.println("CalendarConsumerDto = " + dto);
        producerService.sendMessage(dto);

        return "success";
    }
}
