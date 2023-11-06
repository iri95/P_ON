package com.wanyviny.calendar.domain;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum CALENDAR {
    PROMISE("CALENDAR_PROMISE"), SCHEDULE("CALENDAR_SCHEDULE");

    private final String key;
}
