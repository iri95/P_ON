package com.wanyviny.chat.repository;

import com.wanyviny.chat.entity.Chat;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ChatRepository extends MongoRepository<Chat, String> {

    void deleteChatsByRoomId(String roomId);
}
