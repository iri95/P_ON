package com.wanyviny.calendar.global.kafka.service;

import com.wanyviny.calendar.global.kafka.dto.CalendarConsumerDto;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class KafkaConsumerService {

    @KafkaListener(topics = "from-mysql-userId", groupId = "calendar", containerFactory = "kafkaListener")
    public void consume(CalendarConsumerDto dto){
        System.out.println("name = " + dto.getSender());
        System.out.println("consume message = " + dto.getContext());
    }
}