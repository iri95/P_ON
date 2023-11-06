package com.wanyviny.vote.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wanyviny.vote.dto.VoteCreateRequest;
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
    public void createVote(String roomId, VoteCreateRequest request) {

        Vote vote = modelMapper.map(request, Vote.class);
        vote.setId(roomId);
        voteRepository.save(vote);

        Map<String, Object> field = objectMapper.convertValue(vote, HashMap.class);
        redisTemplate.opsForHash()
                .putAll(roomId, field);
    }

    @Override
    public VoteResponse findVote(String roomId) {

        return objectMapper.convertValue(redisTemplate.opsForHash()
                .entries(roomId), VoteResponse.class);
    }
}
