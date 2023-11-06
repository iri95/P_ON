package com.wanyviny.room.domain.room.service;

import com.wanyviny.room.domain.room.dto.RoomListResponse;
import com.wanyviny.room.domain.room.dto.RoomResponse;

public interface RoomListService {

    void createRoomList(String userId);
    RoomListResponse findRoomList(String userId);
    void addRooms(RoomResponse response);
//    void removeRoom(String roomId, String userId);
    void removeRoomList(String userId);
}
