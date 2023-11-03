package com.wanyviny.promise.domain.room.dto;

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
            List<Map<String, String>> chats,
            List<Map<String, String>> votes
    ) {}

    @Builder
    public record FindDto(

            String id,
            List<Map<String, String>> users,
            String promiseTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation,
            List<Map<String, String>> chats,
            List<Map<String, String>> votes
    ) {}
}
