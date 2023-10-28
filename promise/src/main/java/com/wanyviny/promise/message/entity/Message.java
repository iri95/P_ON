package com.wanyviny.promise.message.entity;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Message {

    private String sender;
    private MessageType messageType;
    private String content;
    private LocalDateTime createAt;
}
