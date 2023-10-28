package com.wanyviny.promise.room.service;

import com.wanyviny.promise.room.dto.RoomListResponse;
import com.wanyviny.promise.room.dto.RoomResponse;

public interface RoomListService {

    void createRoomList(String userId);
    RoomListResponse.FindDto findRoomList(String userId);
    void addRoomList(String userId, RoomResponse.CreateDto roomCreateDto);
}
