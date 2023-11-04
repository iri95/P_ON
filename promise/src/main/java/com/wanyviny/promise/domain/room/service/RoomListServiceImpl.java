package com.wanyviny.promise.domain.room.service;

import com.wanyviny.promise.domain.room.dto.RoomListResponse;
import com.wanyviny.promise.domain.room.dto.RoomListResponse.FindDto;
import com.wanyviny.promise.domain.room.entity.RoomList;
import com.wanyviny.promise.domain.room.repository.RoomListRepository;
import com.wanyviny.promise.domain.room.vo.RoomVo;
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
    public FindDto findRoomList(String userId) {

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

    @Override
    public void deleteRoomList(String userId) {

        roomListRepository.deleteById(userId);
    }
}
