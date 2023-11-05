package com.wanyviny.chat.controller;

import com.wanyviny.chat.common.BasicResponse;
import com.wanyviny.chat.dto.ChatRequest;
import com.wanyviny.chat.dto.ChatResponse;
import com.wanyviny.chat.service.ChatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "채팅", description = "채팅 관련 API")
public class ChatController {

    private final ChatService chatService;

    @MessageMapping("/api/chat/{roomId}/{senderId}")
    @SendTo("/topic/{roomId}")
    public ResponseEntity<BasicResponse> sendChat(
            @DestinationVariable String roomId,
            @DestinationVariable String senderId,
            @RequestBody ChatRequest.SendDto request
    ) {

        request.setRoomId(roomId);
        request.setSenderId(senderId);

        ChatResponse.SendDto response = chatService.sendChat(request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("채팅 발신 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/api/chat/{roomId}/{chatId}")
    @Operation(summary = "채팅 조회", description = "방ID와 채팅ID를 이용하여 채팅을 조회 합니다.")
    public ResponseEntity<BasicResponse> findChat(
            @Parameter(description = "조회할 방ID")
            @PathVariable String roomId,
            @Parameter(description = "조회할 채팅ID")
            @PathVariable String chatId
    ) {

        ChatResponse.FindDto response = chatService.findChat(roomId, chatId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("채팅 조회 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/api/chat/{roomId}")
    @Operation(summary = "방 채팅 조회", description = "방ID를 이용하여 방의 채팅을 조회 합니다.")
    public ResponseEntity<BasicResponse> findAllChat(
            @Parameter(description = "조회할 방ID")
            @PathVariable String roomId
    ) {

        ChatResponse.FindAllDto response = chatService.findAllChat(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("채팅 목록 조회 성공")
                .count(response.getChats().size())
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @DeleteMapping("/api/chat/{roomId}")
    @Operation(summary = "방 채팅 삭제", description = "방ID를 이용하여 방의 채팅을 삭제 합니다.")
    public ResponseEntity<BasicResponse> deleteChats(
            @Parameter(description = "삭제할 방ID")
            @PathVariable String roomId
    ) {

        chatService.deleteChats(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("채팅 목록 삭제 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
