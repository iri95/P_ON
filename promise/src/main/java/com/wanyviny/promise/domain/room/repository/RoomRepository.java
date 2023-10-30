package com.wanyviny.promise.domain.room.repository;

import com.wanyviny.promise.domain.room.entity.Room;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RoomRepository extends MongoRepository<Room, String> {

}
