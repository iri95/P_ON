package com.wanyviny.promise.room.repository;

import com.wanyviny.promise.room.entity.Room;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RoomRepository extends MongoRepository<Room, String> {

}
