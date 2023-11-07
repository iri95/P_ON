package com.wanyviny.vote.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wanyviny.vote.dto.VoteRequest;
import com.wanyviny.vote.dto.VoteResponse;
import com.wanyviny.vote.entity.Vote;
import com.wanyviny.vote.repository.VoteRepository;
import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class VoteServiceImpl implements VoteService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final VoteRepository voteRepository;

    @Override
    public void createVote(String roomId, VoteRequest request) {

        Vote vote = modelMapper.map(request, Vote.class);
        vote.setId(roomId);
        voteRepository.save(vote);
    }

    @Override
    public VoteResponse findVote(String roomId) {

        return modelMapper.map(voteRepository.findById(roomId), VoteResponse.class);
    }

    @Override
    public void modifyVote(String roomId, VoteRequest request) {

        Vote vote = modelMapper.map(request, Vote.class);
        vote.setId(roomId);
        voteRepository.save(vote);
    }
}
