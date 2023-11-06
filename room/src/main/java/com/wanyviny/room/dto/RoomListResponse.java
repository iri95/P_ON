package com.wanyviny.room.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomListResponse {

    private String id;

    @Builder.Default
    private List<Map<String, Object>> rooms = new ArrayList<>();
}
