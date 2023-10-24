package com.wanyviny.user.user;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum PRIVACY {
    PRIVATE("USER_PRIVACY_PRIVATE"), FOLLOWING("USER_PRIVACY_FOLLOWING"), ALL("USER_PRIVACY_ALL");

    private final String key;
}
