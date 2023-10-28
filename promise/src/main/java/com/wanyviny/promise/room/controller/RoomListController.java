package com.wanyviny.promise.room.controller;

import com.wanyviny.promise.room.dto.RoomListResponse;
import com.wanyviny.promise.room.service.RoomListService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/room-list")
@Slf4j
public class RoomListController {

    private final RoomListService roomListService;

    @GetMapping("/{userId}")
    public RoomListResponse.FindDto findRoomList(@PathVariable String userId) {

        return roomListService.findRoomList(userId);
    }

    @PostMapping("/{userId}")
    public void createRoomList(@PathVariable String userId) {

        roomListService.createRoomList(userId);
    }
}
