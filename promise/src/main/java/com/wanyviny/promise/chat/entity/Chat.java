package com.wanyviny.promise.chat.entity;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Chat {

    private String sender;
    private ChatType chatType;
    private String content;
    private LocalDateTime createAt;
}
