package com.wanyviny.promise.domain.user.entity;

import com.wanyviny.promise.domain.room.entity.UserRoom;
import com.wanyviny.promise.domain.vote.dto.VoteDto;
import com.wanyviny.promise.domain.vote.entity.Vote;
import jakarta.persistence.*;
import java.util.List;
import lombok.*;

@ToString
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
    private Long socialId;

    @Column(name = "USER_PASSWORD")
    private String password;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "user")
    private List<UserRoom> userRooms;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "user")
    private List<Vote> votes;

    public VoteDto.get.user entityToDto(){
        return VoteDto.get.user.builder()
                .id(this.id)
                .nickName(this.nickname)
                .profileImage(this.profileImage)
                .build();
    }
}
