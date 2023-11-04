package com.wanyviny.promise.domain.room.dto;

import java.util.List;
import java.util.Map;
import lombok.Builder;

public class RoomListResponse {

    @Builder
    public record FindDto(

            String id,
            List<Map<String, String>> rooms
    ) {}
}
