package com.wanyviny.promise.domain.room.repository;

import com.wanyviny.promise.domain.room.entity.RoomList;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RoomListRepository extends MongoRepository<RoomList, String> {

}
