package com.wanyviny.room.domain.room.repository;

import com.wanyviny.room.domain.room.entity.Room;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RoomRepository extends MongoRepository<Room, String> {

}
