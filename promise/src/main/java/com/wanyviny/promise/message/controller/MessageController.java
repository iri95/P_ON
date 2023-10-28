package com.wanyviny.promise.message.controller;

import com.wanyviny.promise.message.dto.MessageRequest;
import com.wanyviny.promise.message.dto.MessageResponse;
import com.wanyviny.promise.message.service.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/message")
public class MessageController {

    private final MessageService messageService;

    @PostMapping("/{roomId}")
    public MessageResponse.CreateDto createMessage(
            @PathVariable String roomId,
            @RequestBody MessageRequest.CreateDto createDto
    ) {

        return messageService.createMessage(roomId, createDto);
    }
}
