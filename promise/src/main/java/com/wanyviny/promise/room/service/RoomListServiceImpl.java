package com.wanyviny.promise.room.service;

import com.wanyviny.promise.room.dto.RoomListResponse;
import com.wanyviny.promise.room.entity.RoomList;
import com.wanyviny.promise.room.repository.RoomListRepository;
import com.wanyviny.promise.room.vo.RoomVo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoomListServiceImpl implements RoomListService {

    private final RoomListRepository roomListRepository;

    @Override
    public void createRoomList(String userId) {

        roomListRepository.save(RoomList.builder()
                .id(userId)
                .build());
    }

    @Override
    public RoomListResponse.FindDto findRoomList(String userId) {

        RoomList roomList = roomListRepository.findById(userId)
                .orElseThrow();

        return RoomListResponse.FindDto
                .builder()
                .id(roomList.getId())
                .rooms(roomList.getRooms())
                .build();
    }

    @Override
    public void addRoom(String userId, RoomVo roomVo) {

        RoomList roomList = roomListRepository.findById(userId)
                .orElseThrow();

        roomList.addRoom(roomVo);
        roomListRepository.save(roomList);
    }
}
