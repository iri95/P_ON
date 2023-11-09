package com.wanyviny.user.domain.follow.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
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
    private final FirebaseMessaging firebaseMessaging;

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

        String title = "FOLLOW!";
        String body = user.getNickname() + "님이 당신을 팔로우했습니다.";
        String token = following.getPhoneId();

        firebasePushAlarm(title, body, token);
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

    @Transactional
    public void firebasePushAlarm(String title, String Body, String token) {
        Notification notification = Notification.builder()
                .setTitle(title)
                .setBody(Body)
                .setImage("/static/images/default.png")
                .build();

        Message message = Message.builder()
                .setToken(token)  // 친구의 FCM 토큰 설정
                .setNotification(notification)
                .build();
        try {
            firebaseMessaging.send(message);
        } catch (FirebaseMessagingException e) {
            e.printStackTrace();
            throw new IllegalArgumentException("token에 해당하는 유저를 찾을 수 없습니다.");
        }

    }
}
