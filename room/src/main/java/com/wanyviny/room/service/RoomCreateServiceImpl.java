package com.wanyviny.room.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wanyviny.room.dto.RoomCreateRequest;
import com.wanyviny.room.dto.RoomResponse;
import com.wanyviny.room.entity.Room;
import com.wanyviny.room.repository.RoomRepository;
import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class RoomCreateServiceImpl implements RoomCreateService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final RoomRepository roomRepository;

    @Override
    public RoomResponse createRoom(RoomCreateRequest request) {

        Room room = modelMapper.map(request, Room.class);
        room.defaultVotes();
        roomRepository.save(room);

        Map<String, Object> value = objectMapper.convertValue(room, HashMap.class);

        redisTemplate.opsForHash()
                .putAll(room.getId(), value);

        RoomResponse response = modelMapper.map(room, RoomResponse.class);

        if (!StringUtils.hasText(room.getPromiseTitle())) {
            response.changeDefaultTitle();
        }

        return response;
    }
}
