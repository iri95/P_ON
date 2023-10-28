package com.wanyviny.promise.room.dto;

import com.wanyviny.promise.room.entity.Room;
import java.util.List;
import java.util.Map;
import lombok.Builder;

public class RoomListResponse {

    @Builder
    public record FindDto(

            String id,
            String userId,
            List<Map<String, Room>> rooms
    ) {}
}
