package com.wanyviny.user.domain.follow.service;

import com.wanyviny.user.domain.follow.dto.FollowDto;
import com.wanyviny.user.domain.follow.entity.Follow;
import com.wanyviny.user.domain.follow.repository.FollowRepository;
import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.entity.User;
import com.wanyviny.user.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class FollowServiceImpl implements FollowService {

    private final FollowRepository followRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public List<FollowDto> getFollowing(Long userId) {

        List<User> followings = followRepository.findFollowingByUserId(userId);

        return followings.stream()
                .map(User::userDtoToUser)
                .map(userDto -> FollowDto.builder()
                        .follow(userDto)
                        .followBack(followRepository.existsFollowByUserId_IdAndFollowingId_Id(userDto.getId(), userId)).build())
                .sorted().toList();
    }

    @Override
    @Transactional
    public List<FollowDto> getFollower(Long userId) {

        List<User> followers = followRepository.findFollowerByUserId(userId);

        return followers.stream()
                .map(User::userDtoToUser)
                .map(userDto -> FollowDto.builder()
                        .follow(userDto)
                        .followBack(followRepository.existsFollowByUserId_IdAndFollowingId_Id(userId, userDto.getId())).build())
                .sorted().toList();
    }

    @Override
    @Transactional
    public void setFollowing(Long userId, Long followingId) {
        User user = userRepository.findById(userId).orElseThrow(
                () -> new IllegalArgumentException("userId에 해당하는 유저가 없습니다.")
        );
        User following = userRepository.findById(followingId).orElseThrow(
                () -> new IllegalArgumentException("followingId에 해당하는 유저가 없습니다.")
        );

        followRepository.save(Follow.builder()
                .userId(user)
                .followingId(following)
                .build());
    }

    @Override
    @Transactional
    public void deleteFollowing(Long userId, Long followingId) {
        User user = userRepository.findById(userId).orElseThrow(
                () -> new IllegalArgumentException("userId에 해당하는 유저가 없습니다.")
        );
        User following = userRepository.findById(followingId).orElseThrow(
                () -> new IllegalArgumentException("followingId에 해당하는 유저가 없습니다.")
        );

        followRepository.deleteByUserIdAndFollowingId(user, following);
    }
}
