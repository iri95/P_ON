package com.wanyviny.user.domain.user.service;

import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.dto.UserSignUpDto;
import com.wanyviny.user.domain.user.entity.User;
import com.wanyviny.user.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
@Transactional
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    @Value("${kakao.admin}")
    private String SERVICE_APP_ADMIN_KEY;

    private String KAKAO_API_URL = "https://kapi.kakao.com/v1/user";
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

    @Override
    public void update(UserDto userDto, Long id) {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("해당하는 유저가 없습니다.")
        );
        user.update(userDto);
    }

    @Override
    public void logout(Long id) throws Exception {
        String socialId = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("해당하는 유저가 없습니다. ")
        ).getSocialId();

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.add("Authorization", "KakaoAK " + SERVICE_APP_ADMIN_KEY);

            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("target_id_type"   , "user_id");
            params.add("target_id"    , socialId);

            RestTemplate restTemplate = new RestTemplate();
            HttpEntity<MultiValueMap<String, String>> httpEntity = new HttpEntity<>(params, headers);

            ResponseEntity<String> response = restTemplate.exchange(
                    KAKAO_API_URL + "/logout",
                    HttpMethod.POST,
                    httpEntity,
                    String.class
            );
            // TODO : Token관리 추가

        } catch (Exception e) {
            throw new Exception("API call failed");
        }
    }
}
