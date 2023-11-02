package com.wanyviny.user.domain.follow.repository;

import com.wanyviny.user.domain.follow.dto.FollowDto;
import com.wanyviny.user.domain.follow.entity.Follow;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FollowRepository extends JpaRepository<Follow, Long> {
    @Query("SELECT Follow.followingId FROM Follow where Follow.userId.id = :userid")
    List<com.wanyviny.user.domain.user.entity.User> findFollowingByUserId(long userId);

    @Query("SELECT Follow.userId FROM Follow where Follow.followingId.id = :userid")
    List<com.wanyviny.user.domain.user.entity.User> findFollowerByUserId(long userId);
}
