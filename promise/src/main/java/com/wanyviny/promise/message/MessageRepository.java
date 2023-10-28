package com.wanyviny.promise.message;

import com.wanyviny.promise.message.entity.Message;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface MessageRepository extends MongoRepository<Message, String> {

}
