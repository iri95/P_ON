package com.wanyviny.user.global.oauth2;

import com.wanyviny.user.domain.user.Role;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;

import java.util.Collection;
import java.util.Map;

/**
 * DefaultOAuth2User를 상속하고, id와 role 필드를 추가로 가진다.
 */
@Getter
public class CustomOAuth2User extends DefaultOAuth2User {
    private Long id;
    private Role role;

    /**
     * Constructs a {@code DefaultOAuth2User} using the provided parameters.
     *
     * @param authorities       the authorities granted to the user
     * @param attributes        the attributes about the user
     * @param nameAttributeKey  the key used to access the user's "name" from
     *                          {@link #getAttributes()}
     * @param id                user's id
     * @param role              user's role
     *
     */
    public CustomOAuth2User(Collection<? extends GrantedAuthority> authorities,
                            Map<String, Object> attributes, String nameAttributeKey,
                            Long id, Role role) {
        super(authorities, attributes, nameAttributeKey);
        this.id = id;
        this.role = role;
    }
}
