package com.wanyviny.promise.domain.chat.dto;

import com.wanyviny.promise.domain.chat.entity.ChatType;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatResponse {

    private String id;
    private String roomId;
    private String senderId;
    private String sender;
    private ChatType chatType;
    private String content;
    private LocalDateTime createAt;
}
