package com.wanyviny.promise.domain.room.repository;

import com.wanyviny.promise.domain.room.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface RoomRepository extends JpaRepository<Room, Long> {

    List<Room> findByDateCompleteIsOrTimeCompleteIsOrLocationCompleteIs(boolean dateComplete,boolean timeComplete,boolean locationComplete);

    @Modifying
    @Transactional
    @Query("update Room r set r.dateComplete = true, r.timeComplete = true, r.locationComplete = true where r.id = :roomId")
    void completeRoom(Long roomId);

    @Modifying
    @Transactional
    @Query("update Room r set r.dateComplete = true where r.id = :roomId")
    void completeDate(Long roomId);

    @Modifying
    @Transactional
    @Query("update Room r set r.timeComplete = true where r.id = :roomId")
    void completeTime(Long roomId);

    @Modifying
    @Transactional
    @Query("update Room r set r.locationComplete = true where r.id = :roomId")
    void completeLocation(Long roomId);

}
