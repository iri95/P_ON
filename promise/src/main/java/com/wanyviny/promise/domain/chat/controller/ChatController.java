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
import org.springframework.web.bind.annotation.*;

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
            @DestinationVariable String roomId,
            @RequestBody ChatRequest request
    ) {

        ChatResponse response = chatService.sendChat(roomId, request);

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

    @PutMapping("/api/promise/chat/{roomId}/{chatId}")
    @Operation(summary = "마지막으로 읽은 채팅 저장", description = "마지막으로 읽은 채팅 Id를 저장합니다.")
    public ResponseEntity<BasicResponse> postChatId(@RequestHeader("id") Long id,
                                                    @PathVariable("roomId") Long roomId,
                                                    @PathVariable("chatId") String chatId) {

        chatService.setLastChatId(id, roomId, chatId);
        
        BasicResponse basicResponse = BasicResponse.builder()
                .message("마지막으로 일은 채팅 저장 완료")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
