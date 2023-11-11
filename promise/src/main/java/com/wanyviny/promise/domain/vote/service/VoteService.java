package com.wanyviny.promise.domain.vote.service;

import com.wanyviny.promise.domain.vote.dto.VoteDto;

public interface VoteService {

    void postVote(Long userId, VoteDto.post post);

    void updateVote(Long userId, VoteDto.put put);
}
