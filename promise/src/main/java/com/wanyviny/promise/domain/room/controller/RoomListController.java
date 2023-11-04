package com.wanyviny.promise.domain.room.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.room.dto.RoomListResponse;
import com.wanyviny.promise.domain.room.service.RoomListService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/room-list")
@Tag(name = "약속 방 목록", description = "약속 방 목록 관련 API")
public class RoomListController {

    private final RoomListService roomListService;

    @PostMapping("/{userId}")
    @Operation(summary = "약속 방 목록 생성", description = "사용자 아이디 값으로 약속 방 목록을 생성 합니다.")
    public ResponseEntity<BasicResponse> createRoomList(
            @Parameter(description = "생성할 사용자 아이디")
            @PathVariable(name = "userId", required = true) String userId
    ) {

        roomListService.createRoomList(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 목록 생성 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/{userId}")
    @Operation(summary = "약속 방 목록 조회", description = "사용자 아이디 값으로 약속 방 목록을 조회 합니다.")
    public ResponseEntity<BasicResponse> findRoomList(
            @Parameter(description = "조회할 사용자 아이디")
            @PathVariable(name = "userId", required = true) String userId
    ) {

        RoomListResponse.FindDto response = roomListService.findRoomList(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 목록 조회 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();
        
        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @DeleteMapping("/{userId}")
    @Operation(summary = "약속 방 목록 삭제", description = "사용자 아이디 값으로 약속 방 목록을 삭제 합니다.")
    public ResponseEntity<BasicResponse> deleteRoomList(
            @Parameter(description = "삭제할 사용자 아이디")
            @PathVariable(name = "userId", required = true) String userId
    ) {

        roomListService.deleteRoomList(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 목록 삭제 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
