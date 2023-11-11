package com.wanyviny.promise.domain.room.repository;

import com.wanyviny.promise.domain.room.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

public interface RoomRepository extends JpaRepository<Room, Long> {

    @Modifying
    @Transactional
    @Query("update Room r set r.complete = true where r.id = :roomId And r.userId = :userId")
    Integer completeRoom(Long userId, Long roomId);
}
