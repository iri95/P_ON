package com.wanyviny.promise.domain.chat.controller;

import com.wanyviny.promise.domain.chat.dto.ChatRequest;
import com.wanyviny.promise.domain.chat.dto.ChatResponse;
import com.wanyviny.promise.domain.chat.service.ChatService;
import com.wanyviny.promise.domain.common.BasicResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Collections;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@Tag(name = "채팅", description = "채팅 관련 API")
public class ChatController {

    private final ChatService chatService;

    @MessageMapping("/api/promise/chat/{roomId}")
    @SendTo("/topic/chat/{roomId}")
    @Operation(summary = "채팅 발신", description = "채팅을 전송 합니다.")
    public ResponseEntity<BasicResponse> sendChat(
            @RequestHeader("id") String senderId,
            @DestinationVariable String roomId,
            @RequestBody ChatRequest request
    ) {

        log.info("senderId : " + senderId + ", type : " + senderId.getClass());
        log.info("roomId : " + roomId + ", type : " + senderId.getClass());
        log.info("chatType : " + request.getChatType() + ", type : " + request.getChatType().getClass());
        log.info("content : " + request.getContent() + ", type : " + request.getContent().getClass());

        ChatResponse response = chatService.sendChat(senderId, roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("채팅 발신 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/api/promise/chat/{roomId}")
    @Operation(summary = "전체 채팅 조회", description = "전체 채팅을 조회 합니다.")
    public ResponseEntity<BasicResponse> findAllChat(@PathVariable String roomId) {

        List<ChatResponse> response = chatService.findAllChat(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("채팅 전체 조회 성공")
                .count(response.size())
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
