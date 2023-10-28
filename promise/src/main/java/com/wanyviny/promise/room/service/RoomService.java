package com.wanyviny.promise.room.service;

import com.wanyviny.promise.room.dto.RoomRequest;
import com.wanyviny.promise.room.dto.RoomResponse;

public interface RoomService {

    RoomResponse.CreateDto addRoom(String userId, RoomRequest.CreateDto roomCreateDto);
}
