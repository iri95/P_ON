package com.wanyviny.promise.room.service;

import com.wanyviny.promise.room.dto.RoomRequest;
import com.wanyviny.promise.room.dto.RoomResponse;
import com.wanyviny.promise.room.entity.Room;
import com.wanyviny.promise.room.repository.RoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;

    @Override
    public RoomResponse.CreateDto createRoom(RoomRequest.CreateDto roomCreateDto) {

        Room room = roomRepository.save(Room.builder()
                .promiseTitle(roomCreateDto.promiseTitle())
                .promiseDate(roomCreateDto.promiseDate())
                .promiseTime(roomCreateDto.promiseTime())
                .promiseLocation(roomCreateDto.promiseLocation())
                .build());

        return RoomResponse.CreateDto
                .builder()
                .id(room.getId())
                .promiseTitle(room.getPromiseTitle())
                .promiseDate(room.getPromiseDate())
                .promiseTime(room.getPromiseTime())
                .promiseLocation(room.getPromiseLocation())
                .build();
    }

    @Override
    public RoomResponse.FindDto findRoom(String id) {
        return null;
    }
}
