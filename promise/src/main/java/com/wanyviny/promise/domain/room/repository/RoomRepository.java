package com.wanyviny.promise.domain.room.repository;

import com.wanyviny.promise.domain.room.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoomRepository extends JpaRepository<Room, Long> {

}
