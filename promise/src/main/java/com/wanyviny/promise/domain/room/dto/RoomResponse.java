package com.wanyviny.promise.domain.room.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

public class RoomResponse {

    @ToString
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Schema(name = "RoomResponse.Create")
    public static class Create {

        private Long id;
        private Long userId;
        private int userCount;
        private boolean complete;
        private boolean anonymous;
        private boolean multipleChoice;
        private boolean date;
        private boolean time;
        private boolean location;
        private String promiseTitle;
        private String promiseDate;
        private String promiseTime;
        private String promiseLocation;
        private String deadDate;
        private String deadTime;
        private List<Map<String, Object>> users;
    }

    @ToString
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Schema(name = "RoomResponse.Find")
    public static class Find {

        private Long id;
        private Long userId;
        private int userCount;
        private boolean complete;
        private boolean anonymous;
        private boolean multipleChoice;
        private boolean date;
        private boolean time;
        private boolean location;
        private String promiseTitle;
        private String promiseDate;
        private String promiseTime;
        private String promiseLocation;
        private String deadDate;
        private String deadTime;
        private List<Map<String, Object>> users;
    }

    @ToString
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Schema(name = "RoomResponse.FindAll")
    public static class FindAll {

        private Long id;
        private String promiseTitle;
        private String promiseDate;
        private String promiseTime;
        private String promiseLocation;
        private boolean read;
    }
}
