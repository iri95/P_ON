package com.wanyviny.promise.domain.room.repository;

import com.wanyviny.promise.domain.room.entity.UserRoom;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRoomRepository extends JpaRepository<UserRoom, Long> {

    int countAllByRoom_Id(Long roomId);
    List<UserRoom> findAllByUserId(Long userId);
    List<UserRoom> findAllByRoomId(Long roomId);
    void deleteByUserIdAndRoomId(Long userId, Long roomId);
}
