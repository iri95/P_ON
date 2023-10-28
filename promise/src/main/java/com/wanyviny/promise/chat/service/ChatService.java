package com.wanyviny.promise.chat.service;

import com.wanyviny.promise.chat.dto.ChatRequest;
import com.wanyviny.promise.chat.dto.ChatResponse;

public interface ChatService {

    ChatResponse.CreateDto createChat(String roomId, ChatRequest.CreateDto createDto);
}
