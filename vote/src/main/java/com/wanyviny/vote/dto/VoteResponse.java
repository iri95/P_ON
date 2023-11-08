package com.wanyviny.vote.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import java.util.HashMap;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonInclude(Include.NON_NULL)
public class VoteResponse {

    String id;
    String userId;

    @Builder.Default
    Map<String, Object> date = new HashMap<>();

    @Builder.Default
    Map<String, Object> time = new HashMap<>();

    @Builder.Default
    Map<String, Object> location = new HashMap<>();
}
