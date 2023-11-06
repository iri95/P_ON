package com.wanyviny.room.service;

import com.wanyviny.room.dto.RoomModifyRequest;
import com.wanyviny.room.dto.RoomResponse;

public interface RoomModifyService {

    RoomResponse modifyRoom(String roomId, RoomModifyRequest request);
    RoomResponse removeUser(String roomId, String userId);
}
