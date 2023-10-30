package com.wanyviny.promise.domain.room.service;

import com.wanyviny.promise.domain.room.dto.RoomListResponse.FindDto;
import com.wanyviny.promise.domain.room.vo.RoomVo;

public interface RoomListService {

    void createRoomList(String userId);
    FindDto findRoomList(String userId);
    void addRoom(String userId, String roomId, RoomVo roomVo);
}
