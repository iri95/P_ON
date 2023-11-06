package com.wanyviny.vote.service;

import com.wanyviny.vote.dto.VoteCreateRequest;
import com.wanyviny.vote.dto.VoteResponse;

public interface VoteService {

    void createVote(String roomId, VoteCreateRequest request);
    VoteResponse findVote(String roomId);
//    void modifyVote();
}
