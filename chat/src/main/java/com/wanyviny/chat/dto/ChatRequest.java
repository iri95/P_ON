package com.wanyviny.chat.dto;

import com.wanyviny.chat.entity.ChatType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

public class ChatRequest {

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class SendDto {

        private String roomId;
        private String senderId;
        private String sender;
        private String content;
        private String senderProfile;
        private ChatType chatType;
    }
}
