package com.wanyviny.promise.room.repository;

import com.wanyviny.promise.room.entity.RoomList;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RoomListRepository extends MongoRepository<RoomList, String> {

}
