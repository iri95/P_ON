package com.wanyviny.promise.message.service;

import com.wanyviny.promise.message.MessageRepository;
import com.wanyviny.promise.message.dto.MessageRequest;
import com.wanyviny.promise.message.dto.MessageResponse;
import com.wanyviny.promise.message.dto.MessageResponse.CreateDto;
import com.wanyviny.promise.message.entity.Message;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MessageServiceImpl implements MessageService {

    private final MessageRepository messageRepository;

    @Override
    public CreateDto createMessage(MessageRequest.CreateDto createDto) {

        Message message = Message.builder()
                .sender(createDto.sender())
                .messageType(createDto.messageType())
                .createAt(LocalDateTime.now())
                .build();

        messageRepository.save(message);

        return MessageResponse.CreateDto
                .builder()
                .sender(message.getSender())
                .messageType(message.getMessageType())
                .createAt(message.getCreateAt())
                .build();
    }
}
