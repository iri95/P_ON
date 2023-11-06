package com.wanyviny.vote.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.wanyviny.vote.entity.VoteType;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
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
public class VoteCreateRequest {

    private String roomId;
    private VoteType voteType;
    private boolean multiple;
    private boolean anonymous;
    private List<String> items;

    @Schema(nullable = true)
    private String deadLine;
}
