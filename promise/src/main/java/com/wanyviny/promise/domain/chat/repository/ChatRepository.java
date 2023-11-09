package com.wanyviny.promise.domain.chat.repository;

import com.wanyviny.promise.domain.chat.entity.Chat;
import java.util.List;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ChatRepository extends MongoRepository<Chat, String> {

    List<Chat> findAllByRoomId(String roomId);
}
