package com.wanyviny.room.domain.room.controller;

import com.wanyviny.room.global.common.BasicResponse;
import com.wanyviny.room.domain.room.dto.RoomListResponse;
import com.wanyviny.room.domain.room.service.RoomListService;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "약속 목록", description = "약속 목록 관련 API")
public class RoomListController {

    private final RoomListService roomListService;

    @PostMapping("/api/room/list/{userId}")
    public ResponseEntity<BasicResponse> createRoomList(@PathVariable String userId) {

        roomListService.createRoomList(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 목록 생성 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/api/room/list/{userId}")
    public ResponseEntity<BasicResponse> findRoomList(@PathVariable String userId) {

        RoomListResponse response = roomListService.findRoomList(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 목록 조회 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @DeleteMapping("/api/room/list/{userId}")
    public ResponseEntity<BasicResponse> removeRoomList(@PathVariable String userId) {

        roomListService.removeRoomList(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 목록 삭제 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
