package com.wanyviny.room.repository;

import com.wanyviny.room.entity.RoomList;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RoomListRepository extends MongoRepository<RoomList, String> {

}
