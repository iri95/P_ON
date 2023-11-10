package com.wanyviny.promise.domain.chat.dto;

import com.wanyviny.promise.domain.chat.entity.ChatType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatRequest {

    private ChatType chatType;
    private String content;
}
