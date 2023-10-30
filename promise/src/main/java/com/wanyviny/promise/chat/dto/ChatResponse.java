package com.wanyviny.promise.chat.dto;

import com.wanyviny.promise.chat.entity.ChatType;
import java.time.LocalDateTime;
import lombok.Builder;

public class ChatResponse {

    @Builder
    public record CreateDto(

            String roomId,
            String senderId,
            String sender,
            ChatType chatType,
            String content,
            LocalDateTime createAt
    ) {}
}
