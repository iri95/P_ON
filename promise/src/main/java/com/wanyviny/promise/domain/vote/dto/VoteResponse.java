package com.wanyviny.promise.domain.vote.dto;

import com.wanyviny.promise.domain.vote.entity.VoteType;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import lombok.Builder;
import lombok.Getter;

public class VoteResponse {

    @Builder
    public record CreateDto(

            VoteType voteType,
            String title,
            LocalDateTime deadLine,
            List<Map<String, String>> items
    ) {}
}
