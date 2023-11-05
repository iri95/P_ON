package com.wanyviny.chat.dto;

import com.wanyviny.chat.entity.ChatType;
import java.time.LocalDateTime;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

public class ChatResponse {

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class SendDto {

        private String id;
        private String roomId;
        private String senderId;
        private String sender;
        private String senderProfile;
        private String content;
        private ChatType chatType;
        private LocalDateTime createAt;
    }

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class FindDto {

        private String id;
        private String roomId;
        private String senderId;
        private String sender;
        private String senderProfile;
        private String content;
        private ChatType chatType;
        private LocalDateTime createAt;
    }

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class FindAllDto {

        List<FindDto> chats;
    }
}
