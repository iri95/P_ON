package com.wanyviny.promise.domain.room.service;

import com.wanyviny.promise.domain.room.dto.RoomRequest;
import com.wanyviny.promise.domain.room.dto.RoomResponse;
import com.wanyviny.promise.domain.vote.entity.Vote;

public interface RoomService {

    RoomResponse.CreateDto createRoom(RoomRequest.CreateDto request);
    RoomResponse.FindDto findRoom(String roomId);
}
