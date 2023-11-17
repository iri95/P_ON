package com.wanyviny.user.domain.user.dto;

import com.wanyviny.user.domain.user.PRIVACY;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
    private Long id;
    private String profileImage;
    private String nickName;
    private PRIVACY privacy;
    private String stateMessage;
}
