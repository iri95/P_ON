package com.wanyviny.promise.domain.vote.service;

import com.wanyviny.promise.domain.vote.dto.VoteRequest;
import com.wanyviny.promise.domain.vote.dto.VoteResponse;

public interface VoteService {

    VoteResponse.CreateDto createVote(String roomId, VoteRequest.CreateDto request);
    VoteResponse.FindDto findVote(String voteId);
}
