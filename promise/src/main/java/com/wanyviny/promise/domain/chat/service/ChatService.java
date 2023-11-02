package com.wanyviny.promise.domain.chat.service;

import com.wanyviny.promise.domain.chat.dto.ChatRequest;
import com.wanyviny.promise.domain.chat.dto.ChatResponse.CreateDto;

public interface ChatService {

    CreateDto sendChat(String roomId, String senderId, ChatRequest.CreateDto createDto);
}
