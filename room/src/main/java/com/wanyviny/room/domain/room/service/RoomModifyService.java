package com.wanyviny.room.domain.room.service;

import com.wanyviny.room.domain.room.dto.RoomModifyRequest;
import com.wanyviny.room.domain.room.dto.RoomResponse;

public interface RoomModifyService {

    RoomResponse modifyRoom(String roomId, RoomModifyRequest request);
    RoomResponse removeUser(String roomId, String userId);
}
