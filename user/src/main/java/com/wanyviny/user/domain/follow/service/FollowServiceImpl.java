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

    // TODO : 맞팔의 경우 상단에 표시되도록
    @Override
    @Transactional
    public List<FollowDto> getFollowing(Long userId) {
        List<User> followings = followRepository.findFollowingByUserId(userId);
        List<FollowDto> result = new ArrayList<>();

        for (User following : followings
        ) {
            UserDto followInfo = following.userDtoToUser();

            result.add(FollowDto.builder()
                    .follow(followInfo)
                    .followBack(followRepository.countFollowByUserIdAndFollowingId(following.getId(), userId))
                    .build());
        }

        Collections.sort(result);

        return result;
    }

    @Override
    @Transactional
    public List<FollowDto> getFollower(Long userId) {
        List<User> followers = followRepository.findFollowerByUserId(userId);

        List<FollowDto> result = new ArrayList<>();

        for (User follower : followers
        ) {
            UserDto followerInfo = follower.userDtoToUser();

            result.add(FollowDto.builder()
                    .follow(followerInfo)
                    .followBack(followRepository.countFollowByUserIdAndFollowingId(userId, follower.getId()))
                    .build());
        }

        Collections.sort(result);

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
