package com.wanyviny.user.domain.user.service;

import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.dto.UserSignUpDto;
import com.wanyviny.user.domain.user.entity.User;

public interface UserService {

    User getUserProfile(Long id);

    void signUp(UserSignUpDto userSignUpDto, Long id);

    void update(UserDto userDto, Long id);

    void logout(Long id) throws Exception;

    void withdrawal(Long id) throws Exception;

    User getUserByRefreshToken(String refreshToken);
}
