package com.wanyviny.promise.domain.room.service;

import com.wanyviny.promise.domain.room.dto.RoomRequest;

public interface RoomService {

//    RoomResponse.CreateDto createRoom(RoomRequest.CreateDto roomCreateDto);
    void createRoom(RoomRequest.CreateDto roomCreateDto);
}
