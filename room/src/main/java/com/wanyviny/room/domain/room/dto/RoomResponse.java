package com.wanyviny.room.domain.room.dto;

import java.util.List;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomResponse {

    private String id;
    private List<Map<String, String>> users;
    private String promiseTitle;
    private String promiseDate;
    private String promiseTime;
    private String promiseLocation;
}
