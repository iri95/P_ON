package com.wanyviny.promise.room.controller;

import com.wanyviny.promise.room.dto.RoomRequest;
import com.wanyviny.promise.room.dto.RoomResponse;
import com.wanyviny.promise.room.service.RoomListService;
import com.wanyviny.promise.room.service.RoomService;
import com.wanyviny.promise.room.vo.RoomVo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/room")
public class RoomController {

    private final RoomService roomService;
    private final RoomListService roomListService;

    @PostMapping("{userId}")
    public RoomResponse.CreateDto createRoom(
            @PathVariable String userId,
            @RequestBody RoomRequest.CreateDto roomCreateDto
    ) {
        RoomResponse.CreateDto responseDto = roomService.createRoom(userId, roomCreateDto);
        RoomVo roomVo = RoomVo.builder()
                .id(responseDto.id())
                .promiseTitle(responseDto.promiseTitle())
                .promiseDate(responseDto.promiseDate())
                .promiseTime(responseDto.promiseTime())
                .promiseLocation(responseDto.promiseLocation())
                .build();

        roomListService.addRoom(userId, roomVo);
        return responseDto;
    }

//    @GetMapping("/{roomId}")
//    public RoomResponse.FindDto findRoom(@PathVariable String roomId) {
//        return roomService.findRoom(roomId);
//    }
//
//    @PutMapping("/read/{roomId}")
//    public RoomResponse.ReadDto readRoom(@PathVariable String roomId) {
//        return roomService.readRoom(roomId);
//    }
//
//    @PutMapping("/unread/{roomId}")
//    public RoomResponse.UnreadDto unReadRoom(@PathVariable String roomId) {
//        return roomService.unreadRoom(roomId);
//    }
}
