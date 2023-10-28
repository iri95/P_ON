package com.wanyviny.promise.room.service;

import com.wanyviny.promise.room.dto.RoomRequest;
import com.wanyviny.promise.room.dto.RoomResponse;
import com.wanyviny.promise.room.entity.Room;
import com.wanyviny.promise.room.entity.RoomList;
import com.wanyviny.promise.room.repository.RoomListRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoomServiceImpl implements RoomService {

    private final RoomListRepository roomListRepository;

    @Override
    public RoomResponse.CreateDto addRoom(String userId, RoomRequest.CreateDto roomCreateDto) {

        RoomList roomList = roomListRepository.findByUserId(userId)
                .orElseThrow();

        Room room = Room.builder()
                .promiseTitle(roomCreateDto.promiseTitle())
                .promiseDate(roomCreateDto.promiseDate())
                .promiseTime(roomCreateDto.promiseTime())
                .promiseLocation(roomCreateDto.promiseLocation())
                .build();

        roomList.addRoom(room);
        roomListRepository.save(roomList);

        return RoomResponse.CreateDto
                .builder()
                .promiseTitle(room.getPromiseTitle())
                .promiseDate(room.getPromiseDate())
                .promiseTime(room.getPromiseTime())
                .promiseLocation(room.getPromiseLocation())
                .unread(room.isUnread())
                .build();
    }
}
