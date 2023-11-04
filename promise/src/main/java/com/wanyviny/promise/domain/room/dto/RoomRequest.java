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

        @Schema(
                name = "users",
                type = "array",
                nullable = false,
                example = "[{\"userId\" : \"1\", \"nickname\" : \"김태환\"}, {\"userId\" : \"2\", \"nickname\" : \"이상훈\"}]")
        private List<Map<String, String>> users;

        @Schema(name = "promiseTitle", type = "string", nullable = true, defaultValue = "미정")
        private String promiseTitle;

        @Builder.Default
        @Schema(name = "promiseDate", type = "string", nullable = true, defaultValue = "미정")
        private String promiseDate = "미정";

        @Builder.Default
        @Schema(name = "promiseTime", type = "string", nullable = true, defaultValue = "미정")
        private String promiseTime = "미정";

        @Builder.Default
        @Schema(name = "promiseLocation", type = "string", nullable = true, defaultValue = "미정")
        private String promiseLocation = "미정";
    }
}
