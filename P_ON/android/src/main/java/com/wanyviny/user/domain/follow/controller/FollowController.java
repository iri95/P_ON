package com.wanyviny.user.domain.follow.controller;

import com.wanyviny.user.domain.common.BasicResponse;
import com.wanyviny.user.domain.follow.dto.FollowDto;
import com.wanyviny.user.domain.follow.service.FollowService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
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
@Tag(name = "팔로우", description = "팔로우 API")
public class FollowController {

    private final FollowService followService;

    // 팔로잉 조회
    @GetMapping("/following")
    @Operation(summary = "팔로잉 목록 조회", description = "내가 팔로우한 사람을 조회합니다.")
    public ResponseEntity<BasicResponse> getFollowing(@RequestHeader("id") Long id) {

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
    @Operation(summary = "팔로워 목록 조회", description = "나를 팔로우한 사람을 조회합니다.")
    public ResponseEntity<BasicResponse> getFollower(@RequestHeader("id") Long id) {

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
    @Operation(summary = "팔로잉 추가", description = "팔로잉합니다.")
    public ResponseEntity<BasicResponse> setFollowing(@RequestHeader("id") Long id, @PathVariable(name = "followingId") Long followingId) {

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
    @Operation(summary = "팔로잉 삭제", description = "내가 한 팔로우를 취소합니다. -> 팔로잉 취소")
    public ResponseEntity<BasicResponse> deleteFollowing(@RequestHeader("id") Long id, @PathVariable(name = "followingId") Long followingId) {

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
    @Operation(summary = "팔로워 삭제", description = "나를 팔로우한 팔로워를 삭제합니다.")
    public ResponseEntity<BasicResponse> deleteFollower(@RequestHeader("id") Long id, @PathVariable(name = "followerId") Long followerId) {

        followService.deleteFollowing(followerId, id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("팔로워 삭제 완료!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
