package com.wanyviny.alarm.domain.user.entity;


import com.wanyviny.user.domain.user.PRIVACY;
import com.wanyviny.user.domain.user.ROLE;
import com.wanyviny.user.domain.user.dto.UserDto;
import com.wanyviny.user.domain.user.dto.UserSignUpDto;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "USERS")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "USER_ID")
    private Long id;

    @Column(name = "USER_PROFILE_IMAGE", nullable = false)
    private String profileImage;

    @Column(name = "USER_NCIKNAME", nullable = false)
    private String nickname;

    @Column(name = "USER_STATE_MESSAGE")
    private String stateMessage;

    @Column(name = "USER_PRIVACY", nullable = false)
    @Enumerated(EnumType.STRING)
    @Builder.Default
    private PRIVACY privacy = PRIVACY.PRIVATE;

    @Column(name = "USER_PHONE_ID")
    private String phoneId;

    @Column(name = "USER_ROLE", nullable = false)
    @Enumerated(EnumType.STRING)
    private ROLE role;

    @Column(name = "USER_SOCIAL_ID", nullable = false)
    private String socialId;

    @Column(name = "USER_PASSWORD")
    private String password;

    public void signUp(UserSignUpDto userSignUpDto) {
        this.nickname = userSignUpDto.getNickName();
        this.profileImage = userSignUpDto.getProfileImage();
        this.privacy = userSignUpDto.getPrivacy();
        this.stateMessage = userSignUpDto.getStateMessage();
        this.role = ROLE.USER;
    }

    public void update(UserDto userDto) {
        this.nickname = userDto.getNickName();
        this.profileImage = userDto.getProfileImage();
        this.privacy = userDto.getPrivacy();
        this.stateMessage = userDto.getStateMessage();
    }

    public UserDto userDtoToUser() {
        return UserDto.builder()
                .id(this.getId())
                .nickName(this.getNickname())
                .profileImage(this.getProfileImage())
                .privacy(this.getPrivacy())
                .stateMessage(this.getStateMessage())
                .build();
    }

}
