package com.wanyviny.promise.message.dto;

import com.wanyviny.promise.message.entity.MessageType;
import java.time.LocalDateTime;
import lombok.Builder;

public class MessageResponse {

    @Builder
    public record CreateDto(

            String sender,
            MessageType messageType,
            String content,
            LocalDateTime createAt
    ) {}
}
