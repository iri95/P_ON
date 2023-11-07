package com.wanyviny.user.domain.user.service;

import com.wanyviny.user.domain.user.dto.KakaoDto;
import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.dto.UserSignUpDto;
import com.wanyviny.user.domain.user.entity.User;

import java.util.List;
import java.util.Map;

public interface UserService {

    User getUserProfile(Long id);

    void signUp(UserSignUpDto userSignUpDto, Long id);

    void update(UserDto userDto, Long id);

    void logout(Long id) throws Exception;

    void withdrawal(Long id) throws Exception;

    User getUserByRefreshToken(String refreshToken);

    List<UserDto> searchUser(Long userId, String keyword);

    Map<String, String> kakaoLogin(String accessToken) throws Exception;

    KakaoDto getUserInfoWithToken(String accessToken) throws Exception;
}
