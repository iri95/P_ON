package com.wanyviny.user.user.dto;

import lombok.*;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class KakaoDto {

    private Long id;
    private String nickname;
    private String email;
}
