package com.wanyviny.room.controller;

import com.wanyviny.room.common.BasicResponse;
import com.wanyviny.room.dto.RoomCreateRequest;
import com.wanyviny.room.dto.RoomModifyRequest;
import com.wanyviny.room.dto.RoomResponse;
import com.wanyviny.room.service.RoomCreateService;
import com.wanyviny.room.service.RoomFindService;
import com.wanyviny.room.service.RoomListService;
import com.wanyviny.room.service.RoomModifyService;
import com.wanyviny.room.service.RoomRemoveService;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "약속방", description = "약속방 관련 API")
public class RoomController {

    private final RoomCreateService roomCreateService;
    private final RoomFindService roomFindService;
    private final RoomModifyService roomModifyService;
    private final RoomRemoveService roomRemoveService;
    private final RoomListService roomListService;

    @PostMapping("/api/room")
    public ResponseEntity<BasicResponse> createRoom(@RequestBody RoomCreateRequest request) {

        RoomResponse response = roomCreateService.createRoom(request);
        roomListService.addRooms(response);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 생성 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/api/room/{roomId}")
    public ResponseEntity<BasicResponse> findRoom(@PathVariable String roomId) {

        RoomResponse response = roomFindService.findRoom(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 조회 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/api/room/{roomId}")
    public ResponseEntity<BasicResponse> modifyTitle(
            @PathVariable String roomId,
            @RequestBody RoomModifyRequest request
    ) {

        RoomResponse response = roomModifyService.modifyRoom(roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 수정 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        response.setUsers(request.getUsers());
        roomListService.addRooms(response);

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/api/room/{roomId}/out/{userId}")
    public ResponseEntity<BasicResponse> removeUser(
            @PathVariable String roomId, @PathVariable String userId
    ) {

        RoomResponse response = roomModifyService.removeUser(roomId, userId);
//        roomListService.removeRoom(roomId, userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("유저 제외 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @DeleteMapping("/api/room/{roomId}")
    public ResponseEntity<BasicResponse> removeRoom(@PathVariable String roomId) {

        roomRemoveService.removeRoom(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 삭제 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
