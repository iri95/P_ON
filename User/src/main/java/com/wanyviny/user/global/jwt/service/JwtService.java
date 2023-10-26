package com.wanyviny.user.global.jwt.service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.wanyviny.user.user.repository.UserRepository;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
@RequiredArgsConstructor
@Getter
@Slf4j
public class JwtService {

    @Value("${jwt.secretKey}")
    private String secretKey;

    @Value("${jwt.access.expiration}")
    private Long accessTokenExpirationPeriod;

    @Value("${jwt.refresh.expiration}")
    private Long refreshTokenExpirationPeriod;

    @Value("${jwt.access.header}")
    private String accessHeader;

    @Value("${jwt.refresh.header}")
    private String refreshHeader;

    /**
     * JWT의 Subject와 Claim으로 socialId를 사용 -> 클레임의 name을 "socialId"으로 설정
     * JWT의 헤더로 들어오는 값 : 'Authorization(Key) = Bearer {토큰} (Value)'
     */
    private static final String ACCESS_TOKEN_SUBJECT = "AccessToken";
    private static final String REFRESH_TOKEN_SUBJECT = "RefreshToken";
    private static final String ID_CLAIM = "id";
    private static final String BEARER = "Bearer ";

    private final UserRepository userRepository;

    /**
     * AccessToken 생성 메소드
     */
    public String createAccessToken(Long id) {
        Date now = new Date();
        return JWT.create() // JWT토큰을 생성하는 빌더 반환
                .withSubject(ACCESS_TOKEN_SUBJECT)
                .withExpiresAt(new Date(now.getTime() + accessTokenExpirationPeriod))

                // 클레임으로는 socialId 하나만 사용
                // 추가적으로 식별자나, 이름 등의 정보를 더 추가 가능
                // 추가할 경우 .withClaim(클레임 이름, 클레임 값)으로 설정
                .withClaim(ID_CLAIM, id)
                .sign(Algorithm.HMAC512(secretKey)); // HMAC512 알고리즘 사용
    }

    public String createRefreshToken() {
        return "gg";
    }

    public void updateRefreshToken(Long id, String refreshToken) {

    }
}
