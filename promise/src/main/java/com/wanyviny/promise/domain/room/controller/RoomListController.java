package com.wanyviny.promise.domain.room.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.room.dto.RoomListResponse;
import com.wanyviny.promise.domain.room.service.RoomListService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
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

    @PostMapping("/{userId}")
    public ResponseEntity<BasicResponse> createRoomList(@PathVariable String userId) {

        roomListService.createRoomList(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 리스트 생성 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/{userId}")
    public RoomListResponse.FindDto findRoomList(@PathVariable String userId) {

        return roomListService.findRoomList(userId);
    }
}
