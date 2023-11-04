package com.wanyviny.promise.domain.room.dto;

import io.swagger.v3.oas.annotations.media.Schema;
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
    @Schema(name = "RoomRequest.CreateDto")
    public static class CreateDto {

        @Schema(example = "[{\"userId\" : \"string\", \"nickname\" : \"string\"},"
                + "{\"userId\" : \"string\", \"nickname\" : \"string\"}]")
        private List<Map<String, String>> users;

        @Schema(nullable = true)
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
