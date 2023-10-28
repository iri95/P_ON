package com.wanyviny.promise.room.dto;

import lombok.Builder;

public class RoomResponse {

    @Builder
    public record CreateDto(

            String promiseTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation,
            boolean unread
    ) {}

    @Builder
    public record FindDto(

            String promiseTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation,
            boolean unread
    ) {}

    @Builder
    public record ReadDto(

            String promiseTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation,
            boolean unread
    ) {}

    @Builder
    public record UnreadDto(

            String promiseTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation,
            boolean unread
    ) {}
}
