package com.wanyviny.vote.service;

import com.wanyviny.vote.dto.VoteRequest;
import com.wanyviny.vote.dto.VoteResponse;

public interface VoteService {

    void createVote(String userId, String roomId, VoteRequest request);
    VoteResponse findVote(String roomId);
    void modifyVote(String userId, String roomId, VoteRequest request);
}