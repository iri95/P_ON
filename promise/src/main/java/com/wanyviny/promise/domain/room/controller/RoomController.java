package com.wanyviny.promise.domain.room.controller;

import com.wanyviny.promise.domain.room.dto.RoomRequest.CreateDto;
import com.wanyviny.promise.domain.room.service.RoomService;
import com.wanyviny.promise.domain.room.service.RoomListService;
import lombok.RequiredArgsConstructor;
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

//    @PostMapping({"", "/"})
//    public RoomResponse.CreateDto createRoom(@RequestBody RoomRequest.CreateDto roomCreateDto) {
//        RoomResponse.CreateDto responseDto = roomService.createRoom(roomCreateDto);
//        RoomVo roomVo = RoomVo.builder()
//                .promiseTitle(responseDto.promiseTitle())
//                .promiseDate(responseDto.promiseDate())
//                .promiseTime(responseDto.promiseTime())
//                .promiseLocation(responseDto.promiseLocation())
//                .build();
//
//        roomListService.addRoom(userId, responseDto.id(), roomVo);
//        return responseDto;
//    }

//    @PostMapping({"", "/"})
//    public RoomRequest.CreateDto test(@RequestBody RoomRequest.CreateDto roomCreateDto) {
////        RoomResponse.CreateDto responseDto = roomService.createRoom(userId, roomCreateDto);
////        RoomVo roomVo = RoomVo.builder()
////                .promiseTitle(responseDto.promiseTitle())
////                .promiseDate(responseDto.promiseDate())
////                .promiseTime(responseDto.promiseTime())
////                .promiseLocation(responseDto.promiseLocation())
////                .build();
//
//        if (StringUtils.hasText(roomCreateDto.getPromiseTitle())) {
//            roomCreateDto.changeNotDefaultTitle();
//        }
//
//        if (!roomCreateDto.isNotDefaultTitle()) {
//            roomCreateDto.changeTitle();
//        }
//
//        System.out.println(roomCreateDto.getPromiseTitle());
//        return roomCreateDto;
//    }

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

    @PostMapping({"", "/"})
    public void createRoom(@RequestBody CreateDto roomCreateDto) {
        roomService.createRoom(roomCreateDto);
//        RoomVo roomVo = RoomVo.builder()
//                .promiseTitle(responseDto.promiseTitle())
//                .promiseDate(responseDto.promiseDate())
//                .promiseTime(responseDto.promiseTime())
//                .promiseLocation(responseDto.promiseLocation())
//                .build();
//
//        roomListService.addRoom(userId, responseDto.id(), roomVo);
//        return responseDto;
    }
}
