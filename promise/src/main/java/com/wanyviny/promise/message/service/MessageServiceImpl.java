package com.wanyviny.promise.message.service;

import com.wanyviny.promise.message.dto.MessageRequest;
import com.wanyviny.promise.message.dto.MessageResponse;
import com.wanyviny.promise.message.dto.MessageResponse.CreateDto;
import com.wanyviny.promise.message.entity.Message;
import com.wanyviny.promise.room.entity.Room;
import com.wanyviny.promise.room.repository.RoomRepository;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MessageServiceImpl implements MessageService {

    private final RoomRepository roomRepository;

    @Override
    public CreateDto createMessage(String roomId, MessageRequest.CreateDto createDto) {

        Message message = Message.builder()
                .sender(createDto.sender())
                .messageType(createDto.messageType())
                .content(createDto.content())
                .createAt(LocalDateTime.now())
                .build();

        Room room = roomRepository.findById(roomId).orElseThrow();
        room.addMessage(message);
        roomRepository.save(room);

        return MessageResponse.CreateDto
                .builder()
                .sender(message.getSender())
                .messageType(message.getMessageType())
                .content(message.getContent())
                .createAt(message.getCreateAt())
                .build();
    }
}
