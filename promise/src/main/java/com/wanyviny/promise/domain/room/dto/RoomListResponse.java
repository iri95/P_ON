package com.wanyviny.promise.domain.room.dto;

import com.wanyviny.promise.domain.room.vo.RoomVo;
import java.util.Map;
import lombok.Builder;

public class RoomListResponse {

    @Builder
    public record FindDto(

            String id,
            Map<String, RoomVo> rooms
    ) {}
}
