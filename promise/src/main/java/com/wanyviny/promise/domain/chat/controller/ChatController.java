package com.wanyviny.promise.domain.chat.controller;

import com.wanyviny.promise.domain.chat.dto.ChatRequest;
import com.wanyviny.promise.domain.chat.dto.ChatResponse;
import com.wanyviny.promise.domain.chat.service.ChatService;
import com.wanyviny.promise.domain.common.BasicResponse;
import java.util.Collections;
import java.util.List;
import lombok.RequiredArgsConstructor;
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
public class ChatController {

    private final ChatService chatService;

    @MessageMapping("/api/promise/chat/{roomId}")
    @SendTo("/topic/chat/{roomId}")
    public ResponseEntity<BasicResponse> sendChat(
            @RequestHeader("id") String senderId,
            @DestinationVariable String roomId,
            @RequestBody ChatRequest request
    ) {

        ChatResponse response = chatService.sendChat(senderId, roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("채팅 발신 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/api/promise/chat/{roomId}")
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
