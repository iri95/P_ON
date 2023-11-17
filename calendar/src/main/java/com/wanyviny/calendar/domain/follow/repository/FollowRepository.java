package com.wanyviny.calendar.domain.follow.repository;

import com.wanyviny.calendar.domain.follow.entity.Follow;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FollowRepository extends JpaRepository<Follow, Long> {
    boolean existsFollowByUserId_IdAndFollowingId_Id(Long userId, Long followingId);
}
