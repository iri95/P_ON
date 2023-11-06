package com.wanyviny.room.repository;

import com.wanyviny.room.entity.Room;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RoomRepository extends MongoRepository<Room, String> {

}
