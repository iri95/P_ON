package com.wanyviny.promise.room.dto;

import com.wanyviny.promise.room.vo.RoomVo;
import java.util.Map;
import lombok.Builder;

public class RoomListResponse {

    @Builder
    public record FindDto(

            String id,
            Map<String, RoomVo> rooms
    ) {}
}
