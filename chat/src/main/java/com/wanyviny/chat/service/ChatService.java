package com.wanyviny.chat.service;

import com.wanyviny.chat.dto.ChatRequest;
import com.wanyviny.chat.dto.ChatResponse;

public interface ChatService {

    ChatResponse.SendDto sendChat(ChatRequest.SendDto request);
    ChatResponse.FindDto findChat(String roomId, String chatId);
    ChatResponse.FindAllDto findAllChat(String roomId);
    void deleteChats(String roomId);
}
