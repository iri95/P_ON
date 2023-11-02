package com.wanyviny.user.domain.follow.service;

import com.wanyviny.user.domain.follow.repository.FollowRepository;
import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FollowServiceImpl implements FollowService {

    private final FollowRepository followRepository;

    // TODO : 맞팔의 경우 상단에 표시되도록
    @Override
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
}
