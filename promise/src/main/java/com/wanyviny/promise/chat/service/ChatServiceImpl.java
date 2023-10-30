package com.wanyviny.promise.chat.service;

import com.wanyviny.promise.chat.dto.ChatRequest;
import com.wanyviny.promise.chat.dto.ChatResponse;
import com.wanyviny.promise.chat.dto.ChatResponse.CreateDto;
import com.wanyviny.promise.chat.entity.Chat;
import com.wanyviny.promise.domain.room.entity.Room;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final RoomRepository roomRepository;

    @Override
    public CreateDto sendChat(String roomId, String senderId, ChatRequest.CreateDto createDto) {

        Chat chat = Chat.builder()
                .senderId(senderId)
                .sender(createDto.sender())
                .chatType(createDto.chatType())
                .content(createDto.content())
                .createAt(LocalDateTime.now())
                .build();

        Room room = roomRepository.findById(roomId).orElseThrow();
        room.addChat(chat);
        roomRepository.save(room);

        return ChatResponse.CreateDto
                .builder()
                .roomId(roomId)
                .senderId(senderId)
                .sender(chat.getSender())
                .chatType(chat.getChatType())
                .content(chat.getContent())
                .createAt(chat.getCreateAt())
                .build();
    }
}
