package com.wanyviny.chat.repository;

import com.wanyviny.chat.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {

    @Override
    @Query("SELECT r FROM Room r where r.id = :roomId")
    Optional<Room> findById(Long roomId);
}
