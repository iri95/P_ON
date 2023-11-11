package com.wanyviny.promise.domain.vote.service;

import com.wanyviny.promise.domain.user.entity.User;
import com.wanyviny.promise.domain.vote.dto.VoteDto;

import java.util.List;

public interface VoteService {

    void postVote(Long userId, VoteDto.post post);

    void updateVote(Long userId, VoteDto.put put);

    List<String> getUserList(Long itemId);
}
