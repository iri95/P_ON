package com.wanyviny.promise.domain.room.dto;

import java.util.List;
import lombok.Builder;

public class RoomResponse {

    @Builder
    public record CreateDto(

            String id,
            String promiseTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation,
            List<String> users,
            boolean unread
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
