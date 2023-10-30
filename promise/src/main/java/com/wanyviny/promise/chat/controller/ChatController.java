package com.wanyviny.promise.chat.controller;

import com.wanyviny.promise.chat.dto.ChatRequest;
import com.wanyviny.promise.chat.dto.ChatResponse;
import com.wanyviny.promise.chat.service.ChatService;
import lombok.RequiredArgsConstructor;
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
    public ChatResponse.CreateDto createChat(
            @DestinationVariable String roomId,
            @DestinationVariable String senderId,
            @RequestBody ChatRequest.CreateDto createDto
    ) {

        return chatService.createChat(roomId, senderId, createDto);
    }
}
