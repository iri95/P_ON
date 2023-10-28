package com.wanyviny.promise.chat.controller;

import com.wanyviny.promise.chat.dto.ChatRequest;
import com.wanyviny.promise.chat.dto.ChatResponse;
import com.wanyviny.promise.chat.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/chat")
public class ChatController {

    private final ChatService chatService;

    @PostMapping("/{roomId}")
    public ChatResponse.CreateDto createChat(
            @PathVariable String roomId,
            @RequestBody ChatRequest.CreateDto createDto
    ) {

        return chatService.createChat(roomId, createDto);
    }
}
