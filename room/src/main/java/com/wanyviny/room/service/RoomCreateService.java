package com.wanyviny.room.service;

import com.wanyviny.room.dto.RoomCreateRequest;
import com.wanyviny.room.dto.RoomResponse;

public interface RoomCreateService {

    RoomResponse createRoom(RoomCreateRequest request);
}
