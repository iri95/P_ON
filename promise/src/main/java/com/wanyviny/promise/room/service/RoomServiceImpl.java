package com.wanyviny.promise.room.service;

import com.wanyviny.promise.room.dto.RoomRequest;
import com.wanyviny.promise.room.dto.RoomResponse;
import com.wanyviny.promise.room.dto.RoomResponse.ReadDto;
import com.wanyviny.promise.room.dto.RoomResponse.UnreadDto;
import com.wanyviny.promise.room.entity.Room;
import com.wanyviny.promise.room.entity.RoomList;
import com.wanyviny.promise.room.repository.RoomListRepository;
import com.wanyviny.promise.room.repository.RoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;
    private final RoomListRepository roomListRepository;

    @Override
    public RoomResponse.CreateDto createRoom(String userId, RoomRequest.CreateDto roomCreateDto) {
        Room room = Room.builder()
                .promiseTitle(roomCreateDto.promiseTitle())
                .promiseDate(roomCreateDto.promiseDate())
                .promiseTime(roomCreateDto.promiseTime())
                .promiseLocation(roomCreateDto.promiseLocation())
                .build();

        RoomList roomList = roomListRepository.findByUserId(userId).orElseThrow();
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

    @Override
    public RoomResponse.FindDto findRoom(String id) {

        Room room = roomRepository.findById(id).orElseThrow();

        return RoomResponse.FindDto
                .builder()
                .id(room.getId())
                .promiseTitle(room.getPromiseTitle())
                .promiseDate(room.getPromiseDate())
                .promiseTime(room.getPromiseTime())
                .promiseLocation(room.getPromiseLocation())
                .unread(room.isUnread())
                .build();
    }

    @Override
    public ReadDto readRoom(String id) {
        Room room = roomRepository.findById(id).orElseThrow();
        room.read();

        roomRepository.save(room);

        return RoomResponse.ReadDto
                .builder()
                .id(room.getId())
                .promiseTitle(room.getPromiseTitle())
                .promiseDate(room.getPromiseDate())
                .promiseTime(room.getPromiseTime())
                .promiseLocation(room.getPromiseLocation())
                .unread(room.isUnread())
                .build();
    }

    @Override
    public UnreadDto unreadRoom(String id) {
        Room room = roomRepository.findById(id).orElseThrow();
        room.unread();

        roomRepository.save(room);

        return RoomResponse.UnreadDto
                .builder()
                .id(room.getId())
                .promiseTitle(room.getPromiseTitle())
                .promiseDate(room.getPromiseDate())
                .promiseTime(room.getPromiseTime())
                .promiseLocation(room.getPromiseLocation())
                .unread(room.isUnread())
                .build();
    }
}
