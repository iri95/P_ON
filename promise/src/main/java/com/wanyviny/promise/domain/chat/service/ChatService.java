package com.wanyviny.promise.domain.chat.service;

import com.wanyviny.promise.domain.chat.dto.ChatRequest;
import com.wanyviny.promise.domain.chat.dto.ChatResponse;
import java.util.List;

public interface ChatService {

    ChatResponse sendChat(String roomId, ChatRequest request);
    List<ChatResponse> findAllChat(String roomId);
    void setLastChatId(Long userId, Long roomId, String chatId);
}
