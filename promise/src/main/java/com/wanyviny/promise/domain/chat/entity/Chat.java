package com.wanyviny.promise.domain.chat.entity;

import java.time.LocalDateTime;

import com.wanyviny.promise.domain.chat.dto.ChatResponse;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Chat {

    private String id;
    private String roomId;
    private String senderId;
    private String sender;
    private ChatType chatType;
    private String content;

    @CreatedDate
    private LocalDateTime createAt;

    public ChatResponse entityToDto(String profileImage) {
        return ChatResponse.builder()
                .id(this.getId())
                .roomId(this.getRoomId())
                .senderId(this.getSenderId())
                .sender(this.getSender())
                .chatType(this.getChatType())
                .content(this.getContent())
                .createAt(this.getCreateAt())
                .senderProfileImage(profileImage)
                .build();
    }

    public ChatResponse entityToEmpty() {
        return ChatResponse.builder()
                .id(this.getId())
                .roomId(this.getRoomId())
                .senderId(this.getSenderId())
                .sender("알 수 없 음")
                .chatType(this.getChatType())
                .content(this.getContent())
                .createAt(this.getCreateAt())
                .senderProfileImage("http://k.kakaocdn.net/dn/dpk9l1/btqmGhA2lKL/Oz0wDuJn1YV2DIn92f6DVK/img_110x110.jpg")
                .build();
    }
}
