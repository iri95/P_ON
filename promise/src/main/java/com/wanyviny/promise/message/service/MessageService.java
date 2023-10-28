package com.wanyviny.promise.message.service;

import com.wanyviny.promise.message.dto.MessageRequest;
import com.wanyviny.promise.message.dto.MessageResponse;

public interface MessageService {

    MessageResponse.CreateDto createMessage(String roomId, MessageRequest.CreateDto createDto);
}
