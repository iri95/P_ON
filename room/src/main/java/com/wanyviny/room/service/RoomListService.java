package com.wanyviny.room.service;

import com.wanyviny.room.dto.RoomListResponse;
import com.wanyviny.room.dto.RoomModifyRequest;
import com.wanyviny.room.dto.RoomResponse;

public interface RoomListService {

    void createRoomList(String userId);
    RoomListResponse findRoomList(String userId);
    void addRooms(RoomResponse response);
//    void removeRoom(String roomId, String userId);
    void removeRoomList(String userId);
}
