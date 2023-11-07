package com.wanyviny.user.domain.user.controller;

import com.wanyviny.user.domain.common.BasicResponse;
import com.wanyviny.user.domain.user.dto.KakaoDto;
import com.wanyviny.user.domain.user.dto.KakaoUserDto;
import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.dto.UserSignUpDto;
import com.wanyviny.user.domain.user.entity.User;
import com.wanyviny.user.domain.user.service.UserService;
import com.wanyviny.user.global.jwt.service.JwtService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;
    private final JwtService jwtService;


    @PostMapping("/kakao-login")
    public ResponseEntity<BasicResponse> kakaoLogin(HttpServletRequest request) throws Exception {
        String accessToken = request.getHeader("Authorization");
        Map<String, String> tokenMap = userService.kakaoLogin(accessToken);
        HttpHeaders headers = new HttpHeaders();
        if (tokenMap.get("ROLE").equals("GUEST")) {
            headers.add("Authorization", tokenMap.get("Authorization"));
            headers.add("id", tokenMap.get("id"));
            headers.add("ROLE", tokenMap.get("ROLE"));
        } else {
            headers.add("Authorization", tokenMap.get("Authorization"));
            headers.add("Authorization_refresh", tokenMap.get("Authorization_refresh"));
            headers.add("id", tokenMap.get("id"));
            headers.add("ROLE", tokenMap.get("ROLE"));
        }

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("카카오에서 받은 유저 로그인 성공")
                .build();

        return new ResponseEntity<>(basicResponse, headers, basicResponse.getHttpStatus());
    }

    @GetMapping("/kakao-profile")
    public ResponseEntity<BasicResponse> getKakaoProfile(HttpServletRequest request) {
        Long id = Long.parseLong(request.getHeader("id"));

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

    @PostMapping("/sign-up")
    public ResponseEntity<BasicResponse> signup(HttpServletRequest request, @RequestBody UserSignUpDto userSignUpDto) {
        String accessToken = request.getHeader("Authorization").replace("Bearer ", "");

        Long id = Long.parseLong(request.getHeader("id"));

        userService.signUp(userSignUpDto, id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("회원 가입 성공!")
                .build();

        String refreshToken = jwtService.createRefreshToken();

        // 헤더에 토큰 정보 추가
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        headers.add("Authorization_refresh", "Bearer " + refreshToken);

        jwtService.updateRefreshToken(id, refreshToken);

        return new ResponseEntity<>(basicResponse, headers, basicResponse.getHttpStatus());
    }

    @GetMapping("/profile")
    public ResponseEntity<BasicResponse> getProfile(HttpServletRequest request) {
        Long id = Long.parseLong(request.getHeader("id"));

        User userProfile = userService.getUserProfile(id);

        UserDto userDto = UserDto.builder()
                .id(userProfile.getId())
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

    @PutMapping("/update")
    public ResponseEntity<BasicResponse> userUpdate(HttpServletRequest request, @RequestBody UserDto userDto) {
        Long id = Long.parseLong(request.getHeader("id"));

        userService.update(userDto, id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("유저 정보 수정 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/logout")
    public ResponseEntity<BasicResponse> logout(HttpServletRequest request) throws Exception {
        Long id = Long.parseLong(request.getHeader("id"));

        userService.logout(id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("유저 로그아웃 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @DeleteMapping("/withdrawal")
    public ResponseEntity<BasicResponse> withdrawal(HttpServletRequest request) throws Exception {
        Long id = Long.parseLong(request.getHeader("id"));

        userService.withdrawal(id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("회원 탈퇴 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/auto-login")
    public ResponseEntity<BasicResponse> autoLogin(HttpServletRequest request) {
        String refreshToken = jwtService.extractRefreshToken(request)
                .orElseThrow(() -> new IllegalArgumentException("refresh 토큰이 없습니다."));

        User findUser = userService.getUserByRefreshToken(refreshToken);

        String reissueAccessToken = jwtService.createAccessToken();
        String reissueRefreshToken = jwtService.createRefreshToken();

        // 헤더에 토큰 정보 추가
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + reissueAccessToken);
        headers.add("Authorization_refresh", "Bearer " + reissueRefreshToken);

        jwtService.updateRefreshToken(findUser.getId(), reissueRefreshToken);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("자동로그인을 위한 api라 아무 의미없다~")
                .build();

        return new ResponseEntity<>(basicResponse, headers, basicResponse.getHttpStatus());
    }

    @GetMapping("/search/{keyword}")
    public ResponseEntity<BasicResponse> searchUser(HttpServletRequest request, @PathVariable(name = "keyword") String keyword) {
        Long id = Long.parseLong(request.getHeader("id"));

        List<UserDto> userDtoList = userService.searchUser(id, keyword);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("'" + keyword + "'에 대한 검색 결과 입니다.")
                .count(userDtoList.size())
                .result(Arrays.asList(userDtoList.toArray()))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
