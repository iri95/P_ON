package com.wanyviny.promise.chat.dto;

import com.wanyviny.promise.chat.entity.ChatType;
import java.time.LocalDateTime;
import lombok.Builder;

public class ChatRequest {

    @Builder
    public record CreateDto(

            String senderId,
            String sender,
            ChatType chatType,
            String content,
            LocalDateTime createAt
    ) {}
}
