package com.wanyviny.promise.room.dto;

import lombok.Builder;

public class RoomResponse {

    @Builder
    public record CreateDto(

            String id,
            String promiseTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation
    ) {}

    @Builder
    public record FindDto(

            String id,
            String promiseTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation,
            boolean read
    ) {}
}
