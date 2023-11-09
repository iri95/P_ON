package com.wanyviny.chat.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wanyviny.chat.dto.ChatRequest;
import com.wanyviny.chat.dto.ChatResponse;
import com.wanyviny.chat.entity.Chat;
import com.wanyviny.chat.repository.ChatRepository;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ChatServiceImpl implements ChatService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final ChatRepository chatRepository;

    @Override
    @Transactional
    public ChatResponse.SendDto sendChat(ChatRequest.SendDto request) {

        Chat chat = modelMapper.map(request, Chat.class);
        chatRepository.save(chat);

        Map<String, Object> value = objectMapper.convertValue(chat, HashMap.class);
        Map<String, Object> field = new HashMap<>();
        field.put(chat.getId(), value);

        redisTemplate.opsForHash()
                .putAll(chat.getRoomId(), field);

        return modelMapper.map(chat, ChatResponse.SendDto.class);
    }

    @Override
    public ChatResponse.FindDto findChat(String roomId, String chatId) {

        return objectMapper.convertValue(redisTemplate.opsForHash()
                .get(roomId, chatId), ChatResponse.FindDto.class);
    }

    @Override
    public ChatResponse.FindAllDto findAllChat(String roomId) {

        List<ChatResponse.FindDto> chats = new ArrayList<>();
        Map<Object, Object> map = redisTemplate.opsForHash().entries(roomId);

        map.forEach((key, value) -> {
            chats.add(objectMapper.convertValue(value, ChatResponse.FindDto.class));
        });

        return ChatResponse.FindAllDto
                .builder()
                .chats(chats)
                .build();
    }

    @Override
    @Transactional
    public void deleteChats(String roomId) {

        chatRepository.deleteChatsByRoomId(roomId);
        redisTemplate.delete(roomId);
    }
}
