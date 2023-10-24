package com.wanyviny.user.user.entity;


import com.wanyviny.user.user.PRIVACY;
import jakarta.persistence.*;
import lombok.*;
@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "USERS")
public class USERS {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "USER_ID")
    private Long id;

    @Column(name = "USER_PROFILE_URL")
    private String profileUrl;

    @Column(name = "USER_NAME")
    private String name;

    @Column(name = "USER_STATE_MESSAGE")
    private String stateMessage;

    @Column(name = "USER_PRIVACY")
    @Enumerated(EnumType.STRING)
    private PRIVACY privacy;

    @Column(name = "USER_PHONE_ID")
    private String phoneId;

    @Column(name = "USER_REFRESH_TOKEN")
    private String refreshToken;



}
