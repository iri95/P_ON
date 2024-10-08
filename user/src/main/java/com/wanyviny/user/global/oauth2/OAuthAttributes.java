package com.wanyviny.user.global.oauth2;

import com.wanyviny.user.global.oauth2.userinfo.KakaoOAuth2UserInfo;
import com.wanyviny.user.global.oauth2.userinfo.OAuth2UserInfo;
import com.wanyviny.user.domain.user.ROLE;
import com.wanyviny.user.domain.user.entity.User;
import lombok.Builder;
import lombok.Getter;

import java.util.Map;

/**
 * 각 소셜에서 받아오는 데이터가 다르므로
 * 소셜별로 데이터를 받는 데이터를 분기 처리하는 DTO 클래스
 */

@Getter
public class OAuthAttributes {

    private final String nameAttributeKey; // OAuth2 로그인 진행 시 키가 되는 필드 값, PK와 같은 의미
    private final OAuth2UserInfo oauth2UserInfo;

    @Builder
    public OAuthAttributes(String nameAttributeKey, OAuth2UserInfo oauth2UserInfo) {
        this.nameAttributeKey = nameAttributeKey;
        this.oauth2UserInfo = oauth2UserInfo;
    }

    /**
     * 파라미터 : userNameAttributeName -> OAuth2 로그인 시 키(PK)가 되는 값/ attributes : OAuth 서비스의 유저 정보들
     * 각각 소셜 로그인 API에서 제공하는
     * 회원의 식별값(id), attirbutes, nameAttributekey를 저장 후 build
     */

    public static OAuthAttributes of(String userNameAttributeName, Map<String, Object> attributes){
        return OAuthAttributes.builder()
                .nameAttributeKey(userNameAttributeName)
                .oauth2UserInfo(new KakaoOAuth2UserInfo(attributes))
                .build();
    }

    /**
     * of 메소드로 OAuthAttributes 객체가 생성되어, 유저 정보들이 담긴 OAuth2UserInfo가 소셜 타입별로 주입된 상태
     * OAuth2UserInfo에서 socialId(식별값), nickname, profile_image를 가져와 build
     */
    public User toEntity(OAuth2UserInfo oauth2UserInfo){
        return User.builder()
                .socialId(oauth2UserInfo.getId())
                .nickname(oauth2UserInfo.getNickname())
                .profileImage(oauth2UserInfo.getProfileImage())
                .role(ROLE.GUEST)
                .build();
    }
}
