package com.wanyviny.promise.room.dto;

public class RoomRequest {

    public record CreateDto(

            String promiseTitle,
            String promiseDate,
            String promiseTime,
            String promiseLocation
    ) {}
}
