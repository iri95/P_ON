package com.wanyviny.promise.room.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomVo {

    private String id;
    private String promiseTitle;
    private String promiseDate;
    private String promiseTime;
    private String promiseLocation;
    private boolean unread;
}
