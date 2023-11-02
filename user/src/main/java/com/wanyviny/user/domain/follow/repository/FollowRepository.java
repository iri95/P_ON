package com.wanyviny.user.domain.follow.repository;

import com.wanyviny.user.domain.follow.entity.Follow;
import com.wanyviny.user.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface FollowRepository extends JpaRepository<Follow, Long> {
    @Query("SELECT Follow.followingId FROM Follow where Follow.userId.id = :userid")
    List<com.wanyviny.user.domain.user.entity.User> findFollowingByUserId(Long userId);

    @Query("SELECT Follow.userId FROM Follow where Follow.followingId.id = :userid")
    List<com.wanyviny.user.domain.user.entity.User> findFollowerByUserId(Long userId);

    @Transactional
    void deleteByUserIdAndFollowingId(User userId, User followingId);
}
