package com.wanyviny.user.domain.follow.service;

import com.wanyviny.user.domain.follow.dto.FollowDto;
import com.wanyviny.user.domain.user.dto.UserDto;

import java.util.List;

public interface FollowService {
    List<FollowDto> getFollowing(Long userId);

    List<FollowDto> getFollower(Long userId);

    void setFollowing(Long userId, Long followingId);

    void deleteFollowing(Long userId, Long followingId);
}
