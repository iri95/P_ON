package com.wanyviny.user.global.jwt.filter;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.wanyviny.user.global.jwt.service.JwtService;
import com.wanyviny.user.user.repository.UserRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.core.authority.mapping.GrantedAuthoritiesMapper;
import org.springframework.security.core.authority.mapping.NullAuthoritiesMapper;
import org.springframework.util.ObjectUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Date;
import java.util.regex.Pattern;

@RequiredArgsConstructor
@Slf4j
public class JwtAuthenticationProcessingFilter extends OncePerRequestFilter {

    private static final String NO_CHECK_URL = "/auto-login";
    private static final String LOGOUT_URL = "/user-logout";

    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final RedisTemplate redisTemplate;

    private GrantedAuthoritiesMapper authoritiesMapper = new NullAuthoritiesMapper();

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        if (request.getRequestURI().equals(NO_CHECK_URL)) {
            filterChain.doFilter(request, response); // "/login" 요청이 들어오면 다음 필터 호출
            return; // return 이후 현재 필터 진행 막기 (안해주면 아래로 내려가서 계속 필터 진행시킴)
        }

        if (request.getRequestURI().equals((LOGOUT_URL))) {
            jwtService.extractAccessToken(request)
                    .filter(jwtService::isTokenValid)
                    .ifPresent(accessToken -> {
                        // redis에서 access token 확인
//                        String isLogout = (String) redisTemplate.opsForValue().get(accessToken);
//                        if (ObjectUtils.isEmpty(isLogout)) {
//                            DecodedJWT jwt = JWT.decode(accessToken);
//                            Date expiresDate = jwt.getExpiresAt();
//
//                            // 현재 시간과 만료 시간 사이의 시간 차이 계산
//                            long nowMillis = System.currentTimeMillis();
//                            long expirationMillis = expiresDate.getTime();
//                            long remainingMillis = expirationMillis - nowMillis;
//                            redisTemplate.opsForValue().set(accessToken, "logout", remainingMillis, TimeUnit.MILLISECONDS);
//                        }
                    });

            filterChain.doFilter(request, response);
            return;
        }

    }
}
