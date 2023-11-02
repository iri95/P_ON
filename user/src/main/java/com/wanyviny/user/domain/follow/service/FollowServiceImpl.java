package com.wanyviny.user.domain.follow.service;

import com.wanyviny.user.domain.follow.entity.Follow;
import com.wanyviny.user.domain.follow.repository.FollowRepository;
import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.entity.User;
import com.wanyviny.user.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FollowServiceImpl implements FollowService {

    private final FollowRepository followRepository;
    private final UserRepository userRepository;

    // TODO : 맞팔의 경우 상단에 표시되도록
    @Override
    @Transactional
    public List<UserDto> getFollowing(Long userId) {
        List<User> users = followRepository.findFollowingByUserId(userId);
        List<UserDto> result = new ArrayList<>();
        for (User user : users
        ) {
            result.add(UserDto.builder()
                    .id(user.getId())
                    .nickName(user.getNickname())
                    .profileImage(user.getProfileImage())
                    .stateMessage(user.getStateMessage())
                    .build());
        }

        return result;
    }

    @Override
    @Transactional
    public List<UserDto> getFollower(Long userId) {
        List<User> users = followRepository.findFollowerByUserId(userId);
        List<UserDto> result = new ArrayList<>();
        for (User user : users
        ) {
            result.add(UserDto.builder()
                    .id(user.getId())
                    .nickName(user.getNickname())
                    .profileImage(user.getProfileImage())
                    .stateMessage(user.getStateMessage())
                    .build());
        }

        return result;
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
