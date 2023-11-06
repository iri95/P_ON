package com.wanyviny.room.domain.room.service;

import com.wanyviny.room.domain.room.dto.RoomResponse;

public interface RoomFindService {

    RoomResponse findRoom(String roomId);
}
