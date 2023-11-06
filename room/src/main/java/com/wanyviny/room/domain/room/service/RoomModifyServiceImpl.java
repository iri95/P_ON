package com.wanyviny.room.domain.room.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wanyviny.room.domain.room.dto.RoomModifyRequest;
import com.wanyviny.room.domain.room.dto.RoomResponse;
import com.wanyviny.room.domain.room.entity.Room;
import com.wanyviny.room.domain.room.repository.RoomRepository;
import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class RoomModifyServiceImpl implements RoomModifyService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final RoomRepository roomRepository;

    @Override
    public RoomResponse modifyRoom(String roomId, RoomModifyRequest request) {

        Room room = objectMapper.convertValue(redisTemplate.opsForHash()
                .entries(roomId), Room.class);

        if (!request.getUsers().isEmpty()) {
            addUser(room, request);

        } else if (StringUtils.hasText(request.getPromiseTitle())) {
            modifyTitle(room, request);

        } else if (StringUtils.hasText(request.getPromiseDate())) {
            room.setPromiseDate(request.getPromiseDate());

        } else if (StringUtils.hasText(request.getPromiseTime())) {
            room.setPromiseTime(request.getPromiseTime());

        } else {
            room.setPromiseLocation(request.getPromiseLocation());
        }

        roomRepository.save(room);
        redisTemplate.delete(roomId);

        Map<String, Object> value = objectMapper.convertValue(room, HashMap.class);

        redisTemplate.opsForHash()
                .putAll(room.getId(), value);

        return modelMapper.map(room, RoomResponse.class);
    }

    @Override
    public RoomResponse removeUser(String roomId, String userId) {

        Room room = objectMapper.convertValue(redisTemplate.opsForHash()
                .entries(roomId), Room.class);

        room.removeUser(userId);

        if (room.getDefaultTitle().equals("true")) {
            room.changeDefaultTitle();
        }

        roomRepository.save(room);
        redisTemplate.delete(roomId);

        Map<String, Object> value = objectMapper.convertValue(room, HashMap.class);

        redisTemplate.opsForHash()
                .putAll(room.getId(), value);

        return modelMapper.map(room, RoomResponse.class);
    }

    public void addUser(Room room, RoomModifyRequest request) {

        room.addUser(request.getUsers());

        if (room.getDefaultTitle().equals("true")) {
            room.changeDefaultTitle();
        }
    }

    public void modifyTitle(Room room, RoomModifyRequest request) {

        if (StringUtils.hasText(request.getPromiseTitle())) {
            room.setDefaultTitle("false");

        } else {
            room.changeDefaultTitle();
            room.setDefaultTitle("true");
        }

        room.setPromiseTitle(request.getPromiseTitle());
    }
}
