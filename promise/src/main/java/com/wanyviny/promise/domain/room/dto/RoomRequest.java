package com.wanyviny.promise.domain.room.dto;

import java.util.List;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

public class RoomRequest {

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class CreateDto {

        private Map<String, String> users;
        private String promiseTitle;

        @Builder.Default
        private String promiseDate = "미정";

        @Builder.Default
        private String promiseTime = "미정";

        @Builder.Default
        private String promiseLocation = "미정";
    }
}
