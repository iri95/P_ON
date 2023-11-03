package com.wanyviny.promise.domain.room.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.room.dto.RoomRequest;
import com.wanyviny.promise.domain.room.dto.RoomResponse;
import com.wanyviny.promise.domain.room.service.RoomService;
import com.wanyviny.promise.domain.room.service.RoomListService;
import com.wanyviny.promise.domain.room.vo.RoomVo;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
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

    @PostMapping({"", "/"})
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
    public ResponseEntity<BasicResponse> createRoom(@PathVariable String roomId) {

        RoomResponse.FindDto response = roomService.findRoom(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("약속방 조회 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
