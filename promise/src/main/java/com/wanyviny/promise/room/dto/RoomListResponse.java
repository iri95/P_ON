package com.wanyviny.promise.room.dto;

import com.wanyviny.promise.room.vo.RoomVo;
import java.util.List;
import lombok.Builder;

public class RoomListResponse {

    @Builder
    public record FindDto(

            String id,
            List<RoomVo> rooms
    ) {}
}
