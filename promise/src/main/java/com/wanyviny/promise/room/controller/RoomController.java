package com.wanyviny.promise.room.controller;

import com.wanyviny.promise.room.dto.RoomRequest;
import com.wanyviny.promise.room.dto.RoomResponse;
import com.wanyviny.promise.room.service.RoomListService;
import com.wanyviny.promise.room.service.RoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/room")
public class RoomController {

    private final RoomService roomService;
    private final RoomListService roomListService;

    @PostMapping({"", "/"})
    public RoomResponse.CreateDto createRoom(@RequestBody RoomRequest.CreateDto roomCreateDto) {
        return roomService.createRoom("1", roomCreateDto);
    }

    @GetMapping("/{roomId}")
    public RoomResponse.FindDto findRoom(@PathVariable String roomId) {
        return roomService.findRoom(roomId);
    }

    @PutMapping("/read/{roomId}")
    public RoomResponse.ReadDto readRoom(@PathVariable String roomId) {
        return roomService.readRoom(roomId);
    }

    @PutMapping("/unread/{roomId}")
    public RoomResponse.UnreadDto unReadRoom(@PathVariable String roomId) {
        return roomService.unreadRoom(roomId);
    }
}
