package com.wanyviny.user.domain.user.controller;

import com.wanyviny.user.domain.common.BasicResponse;
import com.wanyviny.user.domain.user.PRIVACY;
import com.wanyviny.user.domain.user.dto.KakaoUserDto;
import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.entity.User;
import com.wanyviny.user.domain.user.repository.UserRepository;
import com.wanyviny.user.domain.user.service.UserService;
import com.wanyviny.user.global.jwt.service.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;
    private final UserRepository userRepository;
    private final JwtService jwtService;

    @GetMapping("/kakao-profile")
    public ResponseEntity<BasicResponse> getKakaoProfile() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || authentication.getName() == null || authentication.getName().equals("anonymousUser")) {
            throw new RuntimeException("Security Context에 인증 정보가 없습니다.");
        }
        Long id = Long.parseLong(authentication.getName());
        User userProfile = userService.getUserProfile(id);

        KakaoUserDto kakaoUserDto = KakaoUserDto.builder()
                .profileImage(userProfile.getProfileImage())
                .nickName(userProfile.getNickname())
                .privacy(userProfile.getPrivacy())
                .build();

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("카카오에서 받은 유저 정보 조회 성공")
                .count(1)
                .result(Collections.singletonList(kakaoUserDto))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @RequestMapping("/profile")
    public ResponseEntity<BasicResponse> getProfile() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || authentication.getName() == null || authentication.getName().equals("anonymousUser")) {
            throw new RuntimeException("Security Context에 인증 정보가 없습니다.");
        }
        Long id = Long.parseLong(authentication.getName());
        User userProfile = userService.getUserProfile(id);

        UserDto userDto = UserDto.builder()
                .profileImage(userProfile.getProfileImage())
                .nickName(userProfile.getNickname())
                .privacy(userProfile.getPrivacy())
                .stateMessage(userProfile.getStateMessage())
                .build();

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("유저 정보 조회 성공")
                .count(1)
                .result(Collections.singletonList(userDto))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
