package com.wanyviny.promise.chat.domain.dto;

import com.wanyviny.promise.chat.domain.MessageType;
import java.time.LocalDateTime;
import lombok.Builder;

@Builder
public record ChatDto(
        MessageType messageType,
        String sender,
        String message,
        LocalDateTime createAt
) {}
