package com.wanyviny.user.domain.follow.entity;

import com.wanyviny.user.domain.user.entity.User;
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
@Table(name = "FOLLOWS")
public class Follow {
    @Id
    @Column(name = "FOLLOW_ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @Column(name = "USER_ID")
    @JoinColumn(name = "USER_ID")
    private User userId;

    @ManyToOne
    @Column(name = "FOLLOWING_ID")
    @JoinColumn(name = "USER_ID")
    private User followingId;

}

