package com.wanyviny.promise.chat.domain;

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
public class Chat {

    private MessageType messageType;
    private String sender;
    private String message;

    @CreatedDate
    private LocalDateTime createAt;
}
