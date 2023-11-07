package com.wanyviny.room.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomCreateRequest {

    @Schema(example = "[{\"userId\" : \"string\", \"nickname\" : \"string\"},"
            + "{\"userId\" : \"string\", \"nickname\" : \"string\"}]")
    private List<Map<String, String>> users = new ArrayList<>();

    @Schema(nullable = true)
    private String promiseTitle;

    @Schema(nullable = true)
    private String promiseDate;

    @Schema(nullable = true)
    private String promiseTime;

    @Schema(nullable = true)
    private String promiseLocation;
}
