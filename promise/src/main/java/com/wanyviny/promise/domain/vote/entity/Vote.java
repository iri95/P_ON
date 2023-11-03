package com.wanyviny.promise.domain.vote.entity;

import java.time.LocalDateTime;

public abstract class Vote {

    private String id;
    private VoteType voteType;
    private String title;
    private LocalDateTime deadLine;
}
