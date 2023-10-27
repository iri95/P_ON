package com.wanyviny.user.global.config;

import com.wanyviny.user.global.jwt.filter.JwtAuthenticationProcessingFilter;
import com.wanyviny.user.global.jwt.service.JwtService;
import com.wanyviny.user.oauth2.handler.OAuth2LoginFailureHandler;
import com.wanyviny.user.oauth2.handler.OAuth2LoginSuccessHandler;
import com.wanyviny.user.oauth2.service.CustomOAuth2UserService;
import com.wanyviny.user.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.CsrfConfigurer;
import org.springframework.security.config.annotation.web.configurers.FormLoginConfigurer;
import org.springframework.security.config.annotation.web.configurers.HttpBasicConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.LogoutFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

/**
 * 인증은 CustomJsonUsernamePasswordAuthenticationFilter에서 authenticate()로 인증된 사용자로 처리
 * JwtAuthenticationProcessingFilter는 AccessToken, Refreshtoken 재발급
 */
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final OAuth2LoginSuccessHandler oAuth2LoginSuccessHandler;
    private final OAuth2LoginFailureHandler oAuth2LoginFailureHandler;
    private final CustomOAuth2UserService customOAuth2UserService;
    private final RedisTemplate redisTemplate;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
//        http.cors(configurer -> configurer.configurationSource(corsConfigurationSource()));
        http
                .formLogin(FormLoginConfigurer::disable) // 기본 제공되는 FormLogin 사용 X
                .httpBasic(HttpBasicConfigurer::disable) // httpBasic 사용 X
                .csrf(CsrfConfigurer::disable) // csrf 보안 사용 X -> 서버에 인증 정보를 요청하지 않고 JWT로 할거니까

                // 세션 사용하지 않으므로 STATELESS로 설정
                .sessionManagement(configurer -> configurer.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                //== URL별 권한 관리 옵션 ==//
                // 아이콘, css, js 관련
                // 기본 페이지, css, image, js 하위 폴더에 있는 자료들은 인증없이 모두 접근 가능, h2-console에 접근 가능
//                .authorizeHttpRequests(authorize ->
//                        authorize
//                                .requestMatchers("/", "/v3/api-docs/**", "/swagger-ui/**", "/css/**", "/images/**", "/js/**", "/favicon.ico",
//                                        "/h2-console/**").permitAll()
//                                .requestMatchers(HttpMethod.OPTIONS, "/**/*").permitAll() // options 무시
//                                .requestMatchers("/couple-certification", "/auto-login", "/invitation/share/*", "/user-logout").permitAll()
//                                .anyRequest().authenticated()) // 위의 경로 이외에는 모두 인증된 사용자만 접근 가능)// 커플 인증 요청 접근 가능
                //== 소셜 로그인 설정 ==//
                .oauth2Login(oauth2 -> oauth2
                        .successHandler(oAuth2LoginSuccessHandler) // 동의하고 계속하기를 눌렀을 때 Handler 설정
                        .failureHandler(oAuth2LoginFailureHandler) // 소셜 로그인 실패 시 핸들러 설정
                        .userInfoEndpoint(userInfoEndpointConfig -> userInfoEndpointConfig
                                .userService(customOAuth2UserService))); // customUserService 설정

        // 원래 스프링 시큐리티 필터 순서가 LogoutFilter 이후에 로그인 필터 동작
        // 따라서, LogoutFilter 이후에 우리가 만든 필터 동작하도록 설정
        // 순서 : LogoutFilter -> JwtAuthenticationProcessingFilter -> CustomJsonUsernamePasswordAuthenticationFilter
        //        http.addFilterAfter(customJsonUsernamePasswordAuthenticationFilter(), LogoutFilter.class);
        http.addFilterAfter(jwtAuthenticationProcessingFilter(), LogoutFilter.class);
        //        http.addFilterBefore(jwtAuthenticationProcessingFilter(), CustomJsonUsernamePasswordAuthenticationFilter.class);

        return http.build();


    }
//    @Bean
//    CorsConfigurationSource corsConfigurationSource() {
//        CorsConfiguration configuration = new CorsConfiguration();
//
//        //허용할 url 설정
////		configuration.addAllowedOrigin("http://43.200.254.50");
//        configuration.addAllowedOrigin("https://i9e104.p.ssafy.io");
//        //허용할 헤더 설정
//        configuration.addAllowedHeader("*");
//        //허용할 http method
//        configuration.addAllowedMethod("*");
//        // 클라이언트가 접근 할 수 있는 서버 응답 헤더
//        configuration.addExposedHeader("Authorization");
//        configuration.addExposedHeader("Authorization_refresh");
//        //사용자 자격 증명이 지원되는지 여부
//        configuration.setAllowCredentials(true);
//
//        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
//        source.registerCorsConfiguration("/**", configuration);
//        return source;
//    }
    @Bean
    public JwtAuthenticationProcessingFilter jwtAuthenticationProcessingFilter() {
        return new JwtAuthenticationProcessingFilter(jwtService, userRepository, redisTemplate);
    }
}
