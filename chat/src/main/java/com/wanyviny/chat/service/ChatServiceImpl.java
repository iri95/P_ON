package com.wanyviny.chat.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
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
    private final FirebaseMessaging firebaseMessaging;

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



        String body = "채팅방 알림임다.";

        Notification notification = Notification.builder()
                .setTitle("채팅방 알림")
                .setBody(body)
                .build();

        Message message = Message.builder()
                .setToken("e408feff12bed36c")  // 친구의 FCM 토큰 설정
                .setNotification(notification)
                .build();
        try {
            firebaseMessaging.send(message);
        } catch (FirebaseMessagingException e) {
            e.printStackTrace();
            throw new IllegalArgumentException("알림을 보낼 유저를 찾을 수 없습니다.");
        }

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
