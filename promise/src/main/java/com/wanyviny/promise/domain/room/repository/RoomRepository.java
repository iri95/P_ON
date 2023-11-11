package com.wanyviny.promise.domain.room.repository;

import com.wanyviny.promise.domain.room.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface RoomRepository extends JpaRepository<Room, Long> {

    List<Room> findByCompleteIs(boolean complete);

    @Modifying
    @Transactional
    @Query("update Room r set r.complete = true where r.id = :roomId")
    void completeRoom(Long roomId);
}
