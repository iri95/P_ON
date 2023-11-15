package com.wanyviny.promise.domain.room.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.room.dto.RoomRequest;
import com.wanyviny.promise.domain.room.dto.RoomResponse;
import com.wanyviny.promise.domain.room.service.RoomService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Collections;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/room")
@Tag(name = "약속방", description = "약속방 관련 API")
public class RoomController {

    private final RoomService roomService;

    @PostMapping("")
    @Operation(summary = "약속방 생성", description = "약속방을 생성 합니다.")
    public ResponseEntity<BasicResponse> createRoom(
            @RequestHeader("id") Long userId,
            @RequestBody RoomRequest.Create request
    ) {

        RoomResponse.Create response = roomService.createRoom(userId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 생성 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/{roomId}")
    @Operation(summary = "약속방 조회", description = "약속방을 조회 합니다.")
    public ResponseEntity<BasicResponse> findRoom(@PathVariable Long roomId) {

        RoomResponse.Find response = roomService.findRoom(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 조회 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("")
    @Operation(summary = "약속방 전체 조회", description = "약속방 전체를 조회 합니다.")
    public ResponseEntity<BasicResponse> findAllRoom(@RequestHeader("id") Long userId) {

        List<RoomResponse.FindAll> response = roomService.findAllRoom(userId, false);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 목록 조회 성공")
                .count(response.size())
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/{roomId}/join")
    @Operation(summary = "약속방 들어가기", description = "약속방에 들어갑니다.")
    public ResponseEntity<BasicResponse> joinRoom(
            @RequestHeader("id") Long userId,
            @PathVariable Long roomId
    ) {

        RoomResponse.Join response = roomService.joinRoom(userId, roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 들어가기 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/{roomId}/exit")
    @Operation(summary = "약속방 나가기", description = "약속방에서 나갑니다.")
    public ResponseEntity<BasicResponse> exitRoom(
            @RequestHeader("id") Long userId,
            @PathVariable Long roomId
            ) {

        List<RoomResponse.Exit> response = roomService.exitRoom(userId, roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 나가기 성공")
                .count(response.size())
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @DeleteMapping("/{roomId}")
    @Operation(summary = "약속방 삭제", description = "약속방을 삭제 합니다.")
    public ResponseEntity<BasicResponse> deleteRoom(
            @Parameter(description = "삭제할 약속방 아이디")
            @PathVariable Long roomId
    ) {

        roomService.deleteRoom(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 삭제 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/{roomId}/complete")
    @Operation(summary = "약속방 종료", description = "약속방을 종료합니다.")
    public ResponseEntity<BasicResponse> completePromise(@PathVariable("roomId") Long roomId) {

        roomService.completePromise(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 종료 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/complete")
    @Operation(summary = "종료된 약속방 조회", description = "종료된 약속방을 조회합니다.")
    public ResponseEntity<BasicResponse> getCompletePromise(@RequestHeader("id") Long userId) {

        List<RoomResponse.FindAll> response = roomService.findAllRoom(userId, true);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("종료된 약속방 조회 성공")
                .count(response.size())
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
