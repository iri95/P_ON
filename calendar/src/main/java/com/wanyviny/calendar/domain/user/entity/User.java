package com.wanyviny.calendar.domain.user.entity;

import com.wanyviny.calendar.domain.PRIVACY;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "USERS")
public class User {
    @Id
    @Column(name = "USER_ID")
    private Long id;

    @Column(name = "USER_NCIKNAME", nullable = false)
    private String nickname;

    @Column(name = "USER_PRIVACY", nullable = false)
    @Enumerated(EnumType.STRING)
    @Builder.Default
    private PRIVACY privacy = PRIVACY.PRIVATE;
}
