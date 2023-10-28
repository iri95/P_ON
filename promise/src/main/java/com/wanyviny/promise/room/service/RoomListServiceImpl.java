package com.wanyviny.promise.room.service;

import com.wanyviny.promise.room.dto.RoomListResponse;
import com.wanyviny.promise.room.dto.RoomRequest;
import com.wanyviny.promise.room.dto.RoomResponse;
import com.wanyviny.promise.room.entity.Room;
import com.wanyviny.promise.room.entity.RoomList;
import com.wanyviny.promise.room.repository.RoomListRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoomListServiceImpl implements RoomListService {

    private final RoomListRepository roomListRepository;

    @Override
    public void createRoomList(String userId) {

        roomListRepository.save(RoomList.builder()
                .userId(userId)
                .build());
    }

    @Override
    public RoomListResponse.FindDto findRoomList(String userId) {

        RoomList roomList = roomListRepository.findByUserId(userId)
                .orElseThrow();

        return RoomListResponse.FindDto
                .builder()
                .id(roomList.getId())
                .userId(roomList.getUserId())
                .rooms(roomList.getRooms())
                .build();
    }
}
