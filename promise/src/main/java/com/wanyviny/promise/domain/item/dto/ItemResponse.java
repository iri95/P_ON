package com.wanyviny.promise.domain.item.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

public class ItemResponse {

    @ToString
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Schema(name = "ItemResponse.Create")
    public static class Create {

        private Long id;
        private Long userId;
        private int userCount;
        private boolean complete;
        private boolean dateComplete;
        private boolean timeComplete;
        private boolean locationComplete;
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
    }

    @ToString
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Schema(name = "ItemResponse.Find")
    public static class Find {

        private String deadDate;
        private String deadTime;
        private boolean isAnonymous;
        private boolean isMultipleChoice;

        private List<String> date;
        private List<String> time;
        private List<Map<String, String>> location;
    }

    @ToString
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Schema(name = "ItemResponse.Modify")
    public static class Modify {

        private Long id;
        private Long userId;
        private int userCount;
        private boolean complete;
        private boolean dateComplete;
        private boolean timeComplete;
        private boolean locationComplete;
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
    }
}
