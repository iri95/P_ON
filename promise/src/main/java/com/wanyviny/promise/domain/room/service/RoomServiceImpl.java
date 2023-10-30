package com.wanyviny.promise.domain.room.service;

import com.wanyviny.promise.domain.room.dto.RoomRequest;
import com.wanyviny.promise.domain.room.entity.Room;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;

//    @Override
//    public CreateDto createRoom(RoomRequest.CreateDto roomCreateDto) {
//
//        Room room = Room.builder()
//                .users(roomCreateDto.getUsers())
//                .promiseTitle(roomCreateDto.getPromiseTitle())
//                .promiseDate(roomCreateDto.getPromiseDate())
//                .promiseTime(roomCreateDto.getPromiseTime())
//                .promiseLocation(roomCreateDto.getPromiseLocation())
//                .build();
//
//        roomRepository.save(room);
//
//        return RoomResponse.CreateDto.builder()
//                .id(room.getId())
//                .promiseTitle(room.getPromiseTitle())
//                .promiseDate(room.getPromiseDate())
//                .promiseTime(room.getPromiseTime())
//                .promiseLocation(room.getPromiseLocation())
//                .users(room.getUsers())
//                .build();
//    }

    @Override
    public void createRoom(RoomRequest.CreateDto roomCreateDto) {

        Room room = Room.builder()
                .users(roomCreateDto.getUsers())
                .promiseTitle(roomCreateDto.getPromiseTitle())
                .promiseDate(roomCreateDto.getPromiseDate())
                .promiseTime(roomCreateDto.getPromiseTime())
                .promiseLocation(roomCreateDto.getPromiseLocation())
                .build();

        if (!StringUtils.hasText(room.getPromiseTitle())) {
            room.changeIsDefaultTitle();
            room.changeDefaultTitle();
        }

        roomRepository.save(room);

        System.out.println(room.getUsers().toString());
        System.out.println(room.getPromiseTitle());
        System.out.println(room.getPromiseDate());
        System.out.println(room.getPromiseTime());
        System.out.println(room.getPromiseLocation());
        System.out.println(room.isDefaultTitle());
    }
}
