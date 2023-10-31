package com.wanyviny.user.domain.user.service;

import com.wanyviny.user.domain.user.dto.UserSignUpDto;
import com.wanyviny.user.domain.user.entity.User;
import com.wanyviny.user.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Override
    public User getUserProfile(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(("id에 해당하는 유저가 없습니다.")));
    }

    @Override
    public void signUp(UserSignUpDto userSignUpDto, Long id) {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("해당하는 유저가 없습니다.")
        );
        user.signUp(userSignUpDto);
    }
}
