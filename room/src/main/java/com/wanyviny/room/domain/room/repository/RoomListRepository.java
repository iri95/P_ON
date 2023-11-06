package com.wanyviny.room.domain.room.repository;

import com.wanyviny.room.domain.room.entity.RoomList;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RoomListRepository extends MongoRepository<RoomList, String> {

}
