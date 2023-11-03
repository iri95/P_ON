package com.wanyviny.user.domain.follow.controller;

import com.wanyviny.user.domain.common.BasicResponse;
import com.wanyviny.user.domain.follow.dto.FollowDto;
import com.wanyviny.user.domain.follow.service.FollowService;
import com.wanyviny.user.domain.user.dto.UserDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/follow")
public class FollowController {

    private final FollowService followService;

    // 팔로잉 조회
    @GetMapping("/following")

    public ResponseEntity<BasicResponse> getFollowing() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || authentication.getName() == null || authentication.getName().equals("anonymousUser")) {
            throw new RuntimeException("Security Context에 인증 정보가 없습니다.");
        }

        List<FollowDto> followDtoList =  followService.getFollowing(Long.parseLong(authentication.getName()));

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("팔로잉 목록을 조회했습니다.")
                .count(followDtoList.size())
                .result(Arrays.asList(followDtoList.toArray()))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 팔로워 조회 -> 서로 팔로우한 경우도 함꼐
    @GetMapping("/follower")
    public ResponseEntity<BasicResponse> getFollower() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || authentication.getName() == null || authentication.getName().equals("anonymousUser")) {
            throw new RuntimeException("Security Context에 인증 정보가 없습니다.");
        }

        List<FollowDto> followDtoList =  followService.getFollower(Long.parseLong(authentication.getName()));

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("팔로워 목록을 조회했습니다.")
                .count(followDtoList.size())
                .result(Arrays.asList(followDtoList.toArray()))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 팔로잉 추가
    @PostMapping("/following/{followingId}")
    public ResponseEntity<BasicResponse> setFollowing(@PathVariable(name = "followingId") Long followingId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || authentication.getName() == null || authentication.getName().equals("anonymousUser")) {
            throw new RuntimeException("Security Context에 인증 정보가 없습니다.");
        }

        followService.setFollowing(Long.parseLong(authentication.getName()), followingId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("팔로잉 완료!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 팔로잉 삭제
    @DeleteMapping("/following/{followingId}")
    public ResponseEntity<BasicResponse> deleteFollowing(@PathVariable(name = "followingId") Long followingId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || authentication.getName() == null || authentication.getName().equals("anonymousUser")) {
            throw new RuntimeException("Security Context에 인증 정보가 없습니다.");
        }

        followService.deleteFollowing(Long.parseLong(authentication.getName()), followingId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("팔로잉 취소 완료!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 팔로워 삭제
    @DeleteMapping("/follower/{followerId}")
    public ResponseEntity<BasicResponse> deleteFollower(@PathVariable(name = "followerId") Long followerId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || authentication.getName() == null || authentication.getName().equals("anonymousUser")) {
            throw new RuntimeException("Security Context에 인증 정보가 없습니다.");
        }

        followService.deleteFollowing(followerId, Long.parseLong(authentication.getName()));

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("팔로워 삭제 완료!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
