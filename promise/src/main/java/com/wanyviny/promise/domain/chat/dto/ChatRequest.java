package com.wanyviny.promise.domain.chat.dto;

import com.wanyviny.promise.domain.chat.entity.ChatType;
import lombok.Builder;

public class ChatRequest {

    @Builder
    public record CreateDto(

            String sender,
            ChatType chatType,
            String content
    ) {}
}
