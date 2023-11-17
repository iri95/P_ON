package com.wanyviny.user.global.oauth2.handler;


import com.wanyviny.user.global.jwt.service.JwtService;
import com.wanyviny.user.global.oauth2.CustomOAuth2User;
import com.wanyviny.user.domain.user.ROLE;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.mapping.GrantedAuthoritiesMapper;
import org.springframework.security.core.authority.mapping.NullAuthoritiesMapper;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final JwtService jwtService;
    private GrantedAuthoritiesMapper authoritiesMapper = new NullAuthoritiesMapper();
    @Autowired
    private com.wanyviny.user.domain.user.repository.UserRepository userRepository;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        try {
            CustomOAuth2User oAuth2User = (CustomOAuth2User) authentication.getPrincipal();

            // User의 Role이 GUEST일 경우 처음 요청한 회원이므로 회원가입 페이지로 리다이렉트
            if (oAuth2User.getRole() == ROLE.GUEST) {
                String accessToken = jwtService.createAccessToken();
                response.addHeader(jwtService.getAccessHeader(), "Bearer " + accessToken);
                response.addHeader("id", String.valueOf(oAuth2User.getId()));
                response.sendRedirect(
                        "http://k9e102.p.ssafy.io/wanyviny/main/home?" + "access_token=Bearer " + accessToken + "&is_user=F"
                );
            } else {
                loginSuccess(response, oAuth2User);
            }
        } catch (Exception e) {
            throw e;
        }
    }

    // TODO : 소셜 로그인 시에도 무조건 토큰 생성하지 말고 JWT 인증 필터처럼 RefreshToken 유/무에 따라 다르게 처리해보기
    private void loginSuccess(HttpServletResponse response, CustomOAuth2User oAuth2User) throws IOException {
        String accessToken = jwtService.createAccessToken();
        String refreshToken = jwtService.createRefreshToken();
        response.addHeader(jwtService.getAccessHeader(), "Bearer " + accessToken);
        response.addHeader(jwtService.getRefreshHeader(), "Bearer " + refreshToken);
        response.addHeader("id", String.valueOf(oAuth2User.getId()));
        response.sendRedirect(
                "http://k9e102.p.ssafy.io/wanyviny/main/home?" + "access_token=Bearer " + accessToken + "&refresh_token="
                        + "Bearer " + refreshToken + "&id=" + oAuth2User.getId() + "&is_user=T"
        );

        jwtService.updateRefreshToken(oAuth2User.getId(), refreshToken);
    }

}