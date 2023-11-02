package com.wanyviny.promise.domain.room.dto;

import com.wanyviny.promise.domain.chat.entity.Chat;
import java.util.List;
import java.util.Map;
import lombok.Builder;

public class RoomResponse {

    @Builder
    public record CreateDto(

            String id,
            List<Map<String, String>> users,
            String promiseTitle,
            boolean isDefaultTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation,
            List<Map<String, String>> chats
    ) {}

    @Builder
    public record FindDto(

            String promiseTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation,
            List<String> users,
            boolean unread
    ) {}
}
