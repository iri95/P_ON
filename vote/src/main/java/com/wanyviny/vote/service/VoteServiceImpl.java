package com.wanyviny.vote.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wanyviny.vote.dto.VoteCreateRequest;
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
    public void createVote(VoteCreateRequest request) {

        Vote vote = modelMapper.map(request, Vote.class);
        voteRepository.save(vote);

        Map<String, Object> value = objectMapper.convertValue(vote, HashMap.class);
        Map<String, Object> field = new HashMap<>();
        field.put(String.valueOf(vote.getVoteType()), value);

        redisTemplate.opsForHash()
                .putAll(vote.getRoomId(), field);
    }
}
