package com.wanyviny.promise.room.service;

import com.wanyviny.promise.room.dto.RoomListResponse;
import com.wanyviny.promise.room.vo.RoomVo;

public interface RoomListService {

    void createRoomList(String userId);
    RoomListResponse.FindDto findRoomList(String userId);
    void addRoom(String userId, RoomVo roomVo);
}
