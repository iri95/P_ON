package com.wanyviny.user.domain.user.dto;

import com.wanyviny.user.domain.user.PRIVACY;
import lombok.*;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class KakaoUserDto {
    private String nickName;
    private String profileImage;
    private PRIVACY privacy;
}
