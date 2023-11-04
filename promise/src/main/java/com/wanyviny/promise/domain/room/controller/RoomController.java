package com.wanyviny.promise.domain.room.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.room.dto.RoomRequest;
import com.wanyviny.promise.domain.room.dto.RoomResponse;
import com.wanyviny.promise.domain.room.service.RoomService;
import com.wanyviny.promise.domain.room.service.RoomListService;
import com.wanyviny.promise.domain.room.vo.RoomVo;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/room")
@Tag(name = "약속 방", description = "약속 방 관련 API")
public class RoomController {

    private final RoomService roomService;
    private final RoomListService roomListService;

    @PostMapping("")
    @Operation(summary = "약속 방 생성", description = "약속 방을 생성 합니다.")
    public ResponseEntity<BasicResponse> createRoom(@RequestBody RoomRequest.CreateDto request) {

        RoomResponse.CreateDto response = roomService.createRoom(request);
        RoomVo roomVo = RoomVo.builder()
                .roomId(response.id())
                .promiseTitle(response.promiseTitle())
                .promiseDate(response.promiseDate())
                .promiseTime(response.promiseTime())
                .promiseLocation(response.promiseLocation())
                .build();

        response.users()
                .forEach(user -> {
                    roomListService.addRoom(user.get("userId"), roomVo);
                });

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 생성 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping( "/{roomId}")
    @Operation(summary = "약속 방 조회", description = "약속방 아이디 값으로 약속 방을 조회 합니다.")
    public ResponseEntity<BasicResponse> createRoom(
            @Parameter(description = "조회할 약속 방 아이디")
            @PathVariable(name = "roomId", required = true) String roomId
    ) {

        RoomResponse.FindDto response = roomService.findRoom(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속 방 조회 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @DeleteMapping("/{roomId}")
    @Operation(summary = "약속 방 삭제", description = "약속 방 아이디 값으로 약속 방을 삭제 합니다.")
    public ResponseEntity<BasicResponse> deleteRoom(
            @Parameter(description = "삭제할 약속 방 아이디")
            @PathVariable(name = "roomId", required = true) String roomId
    ) {

        roomService.deleteRoom(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속 방 삭제 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
