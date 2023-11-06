package com.wanyviny.room.domain.room.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wanyviny.room.domain.room.dto.RoomResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoomFindServiceImpl implements RoomFindService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;

    @Override
    public RoomResponse findRoom(String roomId) {

        return objectMapper.convertValue(redisTemplate.opsForHash()
                .entries(roomId), RoomResponse.class);
    }
}
