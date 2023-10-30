package com.wanyviny.user.global.config;

import com.wanyviny.user.global.oauth2.handler.OAuth2LoginFailureHandler;
import com.wanyviny.user.global.oauth2.handler.OAuth2LoginSuccessHandler;
import com.wanyviny.user.global.oauth2.service.CustomOAuth2UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

/**
 * RefreshToken과 AccessToken 발급은 Filter를 통해서 함.
 * MSA이기 때문에 GateWay에서 수행
 */
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final OAuth2LoginSuccessHandler oAuth2LoginSuccessHandler;
    private final OAuth2LoginFailureHandler oAuth2LoginFailureHandler;
    private final CustomOAuth2UserService customOAuth2UserService;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .formLogin(AbstractHttpConfigurer::disable) // 기본 제공되는 FormLogin 사용 X
                .httpBasic(AbstractHttpConfigurer::disable) // httpBasic 사용 X
                .csrf(AbstractHttpConfigurer::disable) // csrf 보안 사용 X -> 서버에 인증 정보를 요청하지 않고 JWT로 할거니까
                .sessionManagement(sessions -> sessions.sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // 세션 사용하지 않으므로 STATELESS로 설정
                //== 소셜 로그인 설정 ==//
                .oauth2Login(configure -> configure
                        .userInfoEndpoint(config -> config.userService(customOAuth2UserService)) // customUserService 설정
                        .successHandler(oAuth2LoginSuccessHandler) // 동의하고 계속하기를 눌렀을 때 Handler 설정
                        .failureHandler(oAuth2LoginFailureHandler) // 소셜 로그인 실패 시 핸들러 설정
                );
        return http.build();
    }
}
