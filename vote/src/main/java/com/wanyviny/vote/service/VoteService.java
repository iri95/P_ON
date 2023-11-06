package com.wanyviny.vote.service;

import com.wanyviny.vote.dto.VoteCreateRequest;

public interface VoteService {

    void createVote(VoteCreateRequest request);
}
