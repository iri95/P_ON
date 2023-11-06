package com.wanyviny.room.domain.room.producer;

import lombok.RequiredArgsConstructor;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class RoomProducer {

    private final KafkaTemplate<String, Object> kafkaTemplate;
}
