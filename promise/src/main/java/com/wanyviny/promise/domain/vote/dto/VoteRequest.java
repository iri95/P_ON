package com.wanyviny.promise.domain.vote.dto;

import com.wanyviny.promise.domain.vote.entity.VoteType;
import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.PathVariable;

public class VoteRequest {

    @Schema(name = "VoteRequest.CreateDto")
    public record CreateDto(

            @Schema(allowableValues = {"DATE", "TIME", "LOCATION"}, example = "TEXT")
            VoteType voteType,
            String title,
            LocalDateTime deadLine,

            @Schema(example = "[{\"string\" : \"string\", \"string\" : \"string\"},"
                    + "{\"string\" : \"string\", \"string\" : \"string\"}]")
            List<Map<String, String>> items
    ) {}
}
