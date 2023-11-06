package com.wanyviny.room.domain.room.service;

import com.wanyviny.room.domain.room.dto.RoomCreateRequest;
import com.wanyviny.room.domain.room.dto.RoomResponse;

public interface RoomCreateService {

    RoomResponse createRoom(RoomCreateRequest request);
}
