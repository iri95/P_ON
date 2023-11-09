package com.wanyviny.promise.domain.chat.service;

import com.wanyviny.promise.domain.chat.dto.ChatRequest;
import com.wanyviny.promise.domain.chat.dto.ChatResponse;
import com.wanyviny.promise.domain.chat.entity.Chat;
import com.wanyviny.promise.domain.chat.repository.ChatRepository;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final ModelMapper modelMapper;
    private final ChatRepository chatRepository;

    @Override
    public ChatResponse sendChat(String senderId, String roomId, ChatRequest request) {

        Chat chat = Chat.builder()
                .roomId(roomId)
                .senderId(senderId)
                .sender(request.getSender())
                .chatType(request.getChatType())
                .content(request.getContent())
                .build();

        chatRepository.save(chat);

        return ChatResponse.builder()
                .id(chat.getId())
                .roomId(roomId)
                .senderId(senderId)
                .sender(chat.getSender())
                .chatType(chat.getChatType())
                .content(chat.getContent())
                .createAt(chat.getCreateAt())
                .build();
    }

    @Override
    public List<ChatResponse> findAllChat(String roomId) {

        List<Chat> chats = chatRepository.findAllByRoomId(roomId);
        List<ChatResponse> response = new ArrayList<>();

        chats.forEach(chat -> response.add(modelMapper.map(chat, ChatResponse.class)));
        return response;
    }
}
