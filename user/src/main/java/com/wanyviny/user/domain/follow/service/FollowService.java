package com.wanyviny.user.domain.follow.service;

import com.wanyviny.user.domain.user.dto.UserDto;

import java.util.List;

public interface FollowService {
    List<UserDto> getFollowing(Long userId);

    List<UserDto> getFollower(Long userId);

    void setFollowing(Long userId, Long followingId);

    void deleteFollowing(Long userId, Long followingId);
}
