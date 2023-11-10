package com.wanyviny.promise.domain.chat.service;

import com.wanyviny.promise.domain.chat.dto.ChatRequest;
import com.wanyviny.promise.domain.chat.dto.ChatResponse;
import com.wanyviny.promise.domain.chat.entity.Chat;
import com.wanyviny.promise.domain.chat.repository.ChatRepository;
import com.wanyviny.promise.domain.user.entity.User;
import com.wanyviny.promise.domain.user.repository.UserRepository;
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
    private final UserRepository userRepository;

    @Override
    public ChatResponse sendChat(String roomId, ChatRequest request) {

        User user = userRepository.findById(Long.parseLong(request.getSenderId())).orElseThrow();

        Chat chat = Chat.builder()
                .roomId(roomId)
                .senderId(request.getSenderId())
                .sender(user.getNickname())
                .chatType(request.getChatType())
                .content(request.getContent())
                .build();

        chatRepository.save(chat);

        return ChatResponse.builder()
                .id(chat.getId())
                .roomId(roomId)
                .senderId(request.getSenderId())
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
