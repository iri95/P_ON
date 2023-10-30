package com.wanyviny.promise.domain.room.vo;

import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomVo {

    private String roomId;
    private String promiseTitle;
    private String promiseDate;
    private String promiseTime;
    private String promiseLocation;
    private boolean unread;
}
