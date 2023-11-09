package com.wanyviny.promise.domain.room.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

public class RoomRequest {

    @ToString
    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Schema(name = "RoomRequest.Create")
    public static class Create {

        private List<Long> users;
        private String promiseTitle;

        @Builder.Default
        @Schema(nullable = true)
        private String promiseDate = "미정";

        @Builder.Default
        @Schema(nullable = true)
        private String promiseTime = "미정";

        @Builder.Default
        @Schema(nullable = true)
        private String promiseLocation = "미정";
    }
}
