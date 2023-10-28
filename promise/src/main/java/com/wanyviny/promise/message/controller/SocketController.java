package com.wanyviny.promise.message.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
public class SocketController {

    private final SimpMessageSendingOperations sendingOperations;

    @MessageMapping("/message")
    public void enter(String message) {
        sendingOperations.convertAndSend("/sub/room", message);
    }
}
