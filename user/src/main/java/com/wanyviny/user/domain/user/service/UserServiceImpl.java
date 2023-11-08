package com.wanyviny.user.domain.user.service;

import com.wanyviny.user.domain.follow.repository.FollowRepository;
import com.wanyviny.user.domain.user.ROLE;
import com.wanyviny.user.domain.user.dto.KakaoDto;
import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.dto.UserSignUpDto;
import com.wanyviny.user.domain.user.entity.User;
import com.wanyviny.user.domain.user.repository.UserRepository;
import com.wanyviny.user.global.jwt.service.JwtService;
import lombok.RequiredArgsConstructor;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    @Value("${kakao.admin}")
    private String SERVICE_APP_ADMIN_KEY;

    private final static String KAKAO_API_URI = "https://kapi.kakao.com";


    private final UserRepository userRepository;
    private final JwtService jwtService;
    private final FollowRepository followRepository;

    @Override
    @Transactional
    public User getUserProfile(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("id에 해당하는 유저가 없습니다."));
    }

    @Override
    @Transactional
    public void signUp(UserSignUpDto userSignUpDto, Long id) {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("Id에 해당하는 유저가 없습니다.")
        );
        user.signUp(userSignUpDto);
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void update(UserDto userDto, Long id) {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("Id에 해당하는 유저가 없습니다.")
        );
        user.update(userDto);
        userRepository.save(user);
    }

    @Override
    @Transactional
    public void logout(Long id) throws Exception {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("Id에 해당하는 유저가 없습니다. ")
        );
        kakaoApi("logout", user.getSocialId());
    }

    @Override
    @Transactional
    public void withdrawal(Long id) throws Exception {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("Id에 해당하는 유저가 없습니다.")
        );

        kakaoApi("unlink", user.getSocialId());
        userRepository.delete(user);
    }

    @Override
    public User getUserByRefreshToken(String refreshToken) {
        return userRepository.findById(jwtService.findIdByRefreshToken(refreshToken)
                        .orElseThrow(() -> new IllegalArgumentException("Refresh Token과 일치하는 사용자 정보가 없습니다.")))
                .orElseThrow(() -> new IllegalArgumentException("Id에 해당하는 유저가 없습니다."));
    }

    @Override
    public List<UserDto> searchUser(Long userId, String keyword) {
        List<User> users = userRepository.findByNicknameContaining(keyword);

        List<Long> followingId = followRepository.findFollowingId_IdByUserId_Id(userId);

        return users.stream()
                .map(User::userDtoToUser)
                .sorted((o1, o2) ->
                        followingId.contains(o1.getId())
                                ? followingId.contains(o2.getId())
                                ? 0 : -1 : 1)
                .toList();
    }

    @Override
    public Map<String, String> kakaoLogin(String accessToken, String phoneId) throws Exception {
        System.out.println("phoneId :" + phoneId);
        KakaoDto kakaoDto = getUserInfoWithToken(accessToken);
        User user = userRepository.findBySocialId(kakaoDto.getSocialId()).orElse(null);
        Map<String, String> tokenMap = new HashMap<>();

        if (user == null) {
            String createdAccessToken = jwtService.createAccessToken();
            tokenMap.put("Authorization", "Bearer " + createdAccessToken);
            tokenMap.put("ROLE", "GUEST");
            User createdUser = userRepository.save(User.builder()
                    .socialId(kakaoDto.getSocialId())
                    .role(ROLE.GUEST)
                    .nickname(kakaoDto.getNickname())
                    .profileImage(kakaoDto.getProfileImage())
                    .phoneId(phoneId)
                    .build());
            tokenMap.put("id", String.valueOf(createdUser.getId()));
            return tokenMap;
        }

        if (user.getRole() == ROLE.GUEST) {
            user.updatePhoneId(phoneId);
            userRepository.save(user);
            String createdAccessToken = jwtService.createAccessToken();
            tokenMap.put("Authorization", "Bearer " + createdAccessToken);
            tokenMap.put("ROLE", "GUEST");
            tokenMap.put("id", String.valueOf(user.getId()));
            return tokenMap;
        }

        // ROLE 이 USER 일 경우
        user.updatePhoneId(phoneId);
        userRepository.save(user);
        String createdAccessToken = jwtService.createAccessToken();
        String createdRefreshToken = jwtService.createRefreshToken();
        jwtService.updateRefreshToken(user.getId(), createdRefreshToken);
        tokenMap.put("Authorization", "Bearer " + createdAccessToken);
        tokenMap.put("Authorization_refresh", "Bearer " + createdRefreshToken);
        tokenMap.put("ROLE", "USER");
        tokenMap.put("id", String.valueOf(user.getId()));
        return tokenMap;


    }


    @Override
    public KakaoDto getUserInfoWithToken(String accessToken) throws Exception {
        //HttpHeader 생성
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        //HttpHeader 담기
        RestTemplate rt = new RestTemplate();
        HttpEntity<MultiValueMap<String, String>> httpEntity = new HttpEntity<>(headers);
        ResponseEntity<String> response = rt.exchange(
                KAKAO_API_URI + "/v2/user/me",
                HttpMethod.POST,
                httpEntity,
                String.class
        );

        //Response 데이터 파싱
        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse(response.getBody());
        JSONObject account = (JSONObject) jsonObj.get("kakao_account");
        JSONObject profile = (JSONObject) account.get("profile");

        Long id = (Long) jsonObj.get("id");
        String email = String.valueOf(account.get("email"));
        String nickname = String.valueOf(profile.get("nickname"));
        String profileImage = (String) profile.get("thumbnail_image_url");

        return KakaoDto.builder()
                .socialId(id)
                .email(email)
                .nickname(nickname)
                .profileImage(profileImage)
                .build();
    }


    public void kakaoApi(String api, Long socialId) throws Exception {
        String KAKAO_API_URL = "https://kapi.kakao.com/v1/user/";
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.add("Authorization", "KakaoAK " + SERVICE_APP_ADMIN_KEY);

            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("target_id_type", "user_id");
            params.add("target_id", String.valueOf(socialId));

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
