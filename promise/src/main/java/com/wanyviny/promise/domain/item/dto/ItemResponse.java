package com.wanyviny.promise.domain.item.dto;

import io.swagger.v3.oas.annotations.media.Schema;
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
