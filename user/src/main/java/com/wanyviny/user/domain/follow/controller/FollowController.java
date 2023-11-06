package com.wanyviny.user.domain.follow.controller;

import com.wanyviny.user.domain.common.BasicResponse;
import com.wanyviny.user.domain.follow.dto.FollowDto;
import com.wanyviny.user.domain.follow.service.FollowService;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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

    public ResponseEntity<BasicResponse> getFollowing(HttpServletRequest request) {
        Long id = Long.parseLong(request.getHeader("id"));

        List<FollowDto> followDtoList = followService.getFollowing(id);

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
    public ResponseEntity<BasicResponse> getFollower(HttpServletRequest request) {
        Long id = Long.parseLong(request.getHeader("id"));

        List<FollowDto> followDtoList = followService.getFollower(id);

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
    public ResponseEntity<BasicResponse> setFollowing(HttpServletRequest request, @PathVariable(name = "followingId") Long followingId) {
        Long id = Long.parseLong(request.getHeader("id"));

        followService.setFollowing(id, followingId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("팔로잉 완료!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 팔로잉 삭제
    @DeleteMapping("/following/{followingId}")
    public ResponseEntity<BasicResponse> deleteFollowing(HttpServletRequest request, @PathVariable(name = "followingId") Long followingId) {
        Long id = Long.parseLong(request.getHeader("id"));

        followService.deleteFollowing(id, followingId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("팔로잉 취소 완료!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 팔로워 삭제
    @DeleteMapping("/follower/{followerId}")
    public ResponseEntity<BasicResponse> deleteFollower(HttpServletRequest request, @PathVariable(name = "followerId") Long followerId) {
        Long id = Long.parseLong(request.getHeader("id"));

        followService.deleteFollowing(followerId, id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("팔로워 삭제 완료!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
