package com.wanyviny.chat.entity;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.mongodb.core.mapping.Document;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document
public class Chat {

    private String id;
    private String roomId;
    private String senderId;
    private String sender;
    private ChatType chatType;
    private String content;

    @Builder.Default
    private String senderProfile = "/images/profile/default.png";

    @CreatedDate
    private LocalDateTime createAt;
}
