package com.wanyviny.room.domain.room.service;

import com.wanyviny.room.domain.room.repository.RoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoomRemoveServiceImpl implements RoomRemoveService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final RoomRepository roomRepository;

    @Override
    public void removeRoom(String roomId) {

        roomRepository.deleteById(roomId);
        redisTemplate.delete(roomId);
    }
}
