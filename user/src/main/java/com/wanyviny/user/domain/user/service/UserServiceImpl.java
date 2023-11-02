package com.wanyviny.user.domain.user.service;

import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.dto.UserSignUpDto;
import com.wanyviny.user.domain.user.entity.User;
import com.wanyviny.user.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
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
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    @Value("${kakao.admin}")
    private String SERVICE_APP_ADMIN_KEY;

    private final UserRepository userRepository;

    @Override
    @Transactional
    public User getUserProfile(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(("id에 해당하는 유저가 없습니다.")));
    }

    @Override
    @Transactional
    public void signUp(UserSignUpDto userSignUpDto, Long id) {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("해당하는 유저가 없습니다.")
        );
        user.signUp(userSignUpDto);
    }

    @Override
    @Transactional
    public void update(UserDto userDto, Long id) {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("해당하는 유저가 없습니다.")
        );
        user.update(userDto);
    }

    @Override
    @Transactional
    public void logout(Long id) throws Exception {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("해당하는 유저가 없습니다. ")
        );
        kakaoApi("logout", user.getSocialId());
    }

    @Override
    @Transactional
    public void withdrawal(Long id) throws Exception {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("해당하는 유저가 없습니다. ")
        );

        kakaoApi("unlink", user.getSocialId());
        userRepository.delete(user);
    }

    public void kakaoApi(String api, String socialId) throws Exception {
        String KAKAO_API_URL = "https://kapi.kakao.com/v1/user/";
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.add("Authorization", "KakaoAK " + SERVICE_APP_ADMIN_KEY);

            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("target_id_type", "user_id");
            params.add("target_id", socialId);

            RestTemplate restTemplate = new RestTemplate();
            HttpEntity<MultiValueMap<String, String>> httpEntity = new HttpEntity<>(params, headers);

            ResponseEntity<String> response = restTemplate.exchange(
                    KAKAO_API_URL + api,
                    HttpMethod.POST,
                    httpEntity,
                    String.class
            );
            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObj = (JSONObject) jsonParser.parse(response.getBody());

            Long userSocialId = (Long) jsonObj.get("id");
            System.out.println("유저 " + api + " 완료 id : " + userSocialId);

        } catch (Exception e) {
            throw new Exception("API call failed");
        }
    }
}
