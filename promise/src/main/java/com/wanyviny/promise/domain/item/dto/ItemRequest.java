package com.wanyviny.promise.domain.item.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

public class ItemRequest {

    @ToString
    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Schema(name = "ItemRequest.Create")
    public static class Create {

        private String deadDate;
        private String deadTime;
        private boolean isAnonymous;
        private boolean isMultipleChoice;

        private List<String> date;
        private List<String> time;
        private List<Map<String, String>> location;
    }
}
