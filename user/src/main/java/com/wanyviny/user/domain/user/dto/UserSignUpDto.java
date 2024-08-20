package com.wanyviny.user.domain.user.dto;

import com.wanyviny.user.domain.user.PRIVACY;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UserSignUpDto {
    private String nickName;
    private PRIVACY privacy;
    private String profileImage;
    private String stateMessage;
}
