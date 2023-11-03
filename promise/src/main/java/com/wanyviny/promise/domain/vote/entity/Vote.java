package com.wanyviny.promise.domain.vote.entity;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Vote {

    private String id;
    private VoteType voteType;
    private String title;
    private LocalDateTime deadLine;
    private List<Map<String, String>> items;
}
