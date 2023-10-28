package com.wanyviny.promise.room.service;

import com.wanyviny.promise.room.dto.RoomRequest;
import com.wanyviny.promise.room.dto.RoomResponse;

public interface RoomService {

    RoomResponse.CreateDto createRoom(RoomRequest.CreateDto roomCreateDto);
    RoomResponse.FindDto findRoom(String id);
}
