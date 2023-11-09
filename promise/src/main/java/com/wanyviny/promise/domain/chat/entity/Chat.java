package com.wanyviny.promise.domain.chat.entity;

import java.time.LocalDateTime;
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
}
