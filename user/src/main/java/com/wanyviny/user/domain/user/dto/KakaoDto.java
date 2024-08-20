package com.wanyviny.user.domain.user.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class KakaoDto {

    private Long socialId;
    private String nickname;
    private String email;
    private String profileImage;
}
