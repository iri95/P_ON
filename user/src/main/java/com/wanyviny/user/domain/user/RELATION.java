package com.wanyviny.user.domain.user;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum RELATION {
    FOLLOWING("RELATION_FOLLOWING"), FOLLOWER("RELATION_FOLLOWER"), NON("RELATION_NON");

    private final String key;
}
