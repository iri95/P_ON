package com.wanyviny.room.domain.room.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wanyviny.room.domain.room.dto.RoomListRequest;
import com.wanyviny.room.domain.room.dto.RoomListResponse;
import com.wanyviny.room.domain.room.dto.RoomResponse;
import com.wanyviny.room.domain.room.entity.RoomList;
import com.wanyviny.room.domain.room.repository.RoomListRepository;
import java.util.HashMap;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoomListServiceImpl implements RoomListService {

    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private final RoomListRepository roomListRepository;

    @Override
    public void createRoomList(String userId) {

        RoomList roomList = roomListRepository.save(RoomList.builder()
                .id(userId)
                .build());

        Map<String, Object> value = objectMapper.convertValue(roomList, HashMap.class);

        redisTemplate.opsForHash()
                .putAll(roomList.getId(), value);
    }

    @Override
    public RoomListResponse findRoomList(String userId) {

        RoomList roomList = objectMapper.convertValue(redisTemplate.opsForHash()
                .entries(userId), RoomList.class);

        RoomListResponse response = RoomListResponse.builder()
                .id(roomList.getId())
                .build();

        roomList.getRooms()
                .forEach(room -> {

                    Map<String, Object> map = objectMapper.convertValue(redisTemplate.opsForHash()
                            .entries(room.get("roomId")), HashMap.class);

                    map.put("")

                    response.getRooms()
                            .add(objectMapper.convertValue(redisTemplate.opsForHash()
                                    .entries(room.get("roomId")), HashMap.class));
                });

        return response;
    }

    @Override
    public void addRooms(RoomResponse response) {
        RoomListRequest roomDto = objectMapper.convertValue(response, RoomListRequest.class);
        roomDto.setRoomId(response.getId());
        roomDto.setRead("읽음");

        response.getUsers()
                .forEach(user -> {
                    String userId = user.get("userId");
                    addRoom(userId, roomDto);
                });
    }

//    @Override
//    public void removeRoom(String roomId, String userId) {
//
//        RoomList roomList = objectMapper.convertValue(redisTemplate.opsForHash()
//                .entries(userId), RoomList.class);
//
//        roomList.removeRoom(roomId);
//        roomListRepository.save(roomList);
//        redisTemplate.delete(userId);
//
//        Map<String, Object> value = objectMapper.convertValue(roomList, HashMap.class);
//
//        redisTemplate.opsForHash()
//                .putAll(roomList.getId(), value);
//    }

    @Override
    public void removeRoomList(String userId) {

        roomListRepository.deleteById(userId);
        redisTemplate.delete(userId);
    }

    public void addRoom(String userId, RoomListRequest roomDto) {

        RoomList roomList = objectMapper.convertValue(redisTemplate.opsForHash()
                .entries(userId), RoomList.class);

        Map<String, String> room = objectMapper.convertValue(roomDto, HashMap.class);
        roomList.addRoom(room);
        roomListRepository.save(roomList);

        Map<String, Object> value = objectMapper.convertValue(roomList, HashMap.class);

        redisTemplate.opsForHash()
                .putAll(roomList.getId(), value);
    }
}
