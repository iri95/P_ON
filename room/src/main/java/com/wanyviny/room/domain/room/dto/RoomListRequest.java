package com.wanyviny.room.domain.room.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RoomListRequest {

    private String roomId;
    private String promiseTitle;
    private String promiseDate;
    private String promiseTime;
    private String promiseLocation;
    private String read;
}
