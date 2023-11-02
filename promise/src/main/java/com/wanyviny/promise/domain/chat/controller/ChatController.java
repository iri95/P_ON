package com.wanyviny.promise.domain.chat.controller;

import com.wanyviny.promise.domain.chat.dto.ChatRequest;
import com.wanyviny.promise.domain.chat.service.ChatService;
import com.wanyviny.promise.domain.chat.dto.ChatResponse.CreateDto;
import com.wanyviny.promise.domain.common.BasicResponse;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/chat")
public class ChatController {

    private final ChatService chatService;

    @MessageMapping("/chat/{roomId}/{senderId}")
    @SendTo("/topic/chat/{roomId}")
    public ResponseEntity<BasicResponse> sendChat(
            @DestinationVariable String roomId,
            @DestinationVariable String senderId,
            @RequestBody ChatRequest.CreateDto createDto
    ) {

        CreateDto response = chatService.sendChat(roomId, senderId, createDto);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("채팅 발신 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
