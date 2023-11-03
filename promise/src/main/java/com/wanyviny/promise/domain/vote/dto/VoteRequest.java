package com.wanyviny.promise.domain.vote.dto;

import com.wanyviny.promise.domain.vote.entity.VoteType;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public class VoteRequest {

    public record CreateDto(

            String id,
            VoteType voteType,
            String title,
            LocalDateTime deadLine,
            List<Map<String, String>> items
    ) {}
}
