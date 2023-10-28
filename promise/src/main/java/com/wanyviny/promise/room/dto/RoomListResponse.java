package com.wanyviny.promise.room.dto;

import com.wanyviny.promise.room.entity.Room;
import java.util.List;
import lombok.Builder;

public class RoomListResponse {

    @Builder
    public record FindDto(

            String id,
            String userId,
            List<Room> rooms
    ) {}
}
