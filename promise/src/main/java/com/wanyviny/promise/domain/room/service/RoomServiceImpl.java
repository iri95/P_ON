package com.wanyviny.promise.domain.room.service;

import com.wanyviny.promise.domain.room.dto.RoomRequest;
import com.wanyviny.promise.domain.room.dto.RoomResponse;
import com.wanyviny.promise.domain.room.dto.RoomResponse.FindDto;
import com.wanyviny.promise.domain.room.entity.Room;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import com.wanyviny.promise.domain.vote.entity.Vote;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;

    @Override
    public RoomResponse.CreateDto createRoom(RoomRequest.CreateDto request) {

        Room room = Room.builder()
                .users(request.getUsers())
                .promiseTitle(request.getPromiseTitle())
                .promiseDate(request.getPromiseDate())
                .promiseTime(request.getPromiseTime())
                .promiseLocation(request.getPromiseLocation())
                .build();

        if (!StringUtils.hasText(room.getPromiseTitle())) {
            room.changeIsDefaultTitle();
            room.changeDefaultTitle();
        }

        roomRepository.save(room);

        return RoomResponse.CreateDto.builder()
                .id(room.getId())
                .users(room.getUsers())
                .isDefaultTitle(room.isDefaultTitle())
                .promiseTitle(room.getPromiseTitle())
                .promiseDate(room.getPromiseDate())
                .promiseTime(room.getPromiseTime())
                .promiseLocation(room.getPromiseLocation())
                .chats(room.getChats())
                .votes(room.getVotes())
                .build();
    }

    @Override
    public FindDto findRoom(String roomId) {

        Room room = roomRepository.findById(roomId).orElseThrow();

        return RoomResponse.FindDto
                .builder()
                .id(room.getId())
                .users(room.getUsers())
                .promiseTitle(room.getPromiseTitle())
                .promiseDate(room.getPromiseDate())
                .promiseTime(room.getPromiseTime())
                .promiseLocation(room.getPromiseLocation())
                .chats(room.getChats())
                .votes(room.getVotes())
                .build();
    }

    @Override
    public void deleteRoom(String roomId) {

        roomRepository.deleteById(roomId);
    }
}
