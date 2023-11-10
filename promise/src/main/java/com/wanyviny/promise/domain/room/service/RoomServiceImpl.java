package com.wanyviny.promise.domain.room.service;

import com.wanyviny.promise.domain.item.entity.ItemType;
import com.wanyviny.promise.domain.item.repository.ItemRepository;
import com.wanyviny.promise.domain.room.dto.RoomRequest;
import com.wanyviny.promise.domain.room.dto.RoomResponse;
import com.wanyviny.promise.domain.room.entity.Room;
import com.wanyviny.promise.domain.room.entity.UserRoom;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import com.wanyviny.promise.domain.room.repository.UserRoomRepository;
import com.wanyviny.promise.domain.user.entity.User;
import com.wanyviny.promise.domain.user.repository.UserRepository;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RoomServiceImpl implements RoomService {

    private final ModelMapper modelMapper;
    private final RoomRepository roomRepository;
    private final UserRepository userRepository;
    private final UserRoomRepository userRoomRepository;
    private final ItemRepository itemRepository;

    @Override
    @Transactional
    public RoomResponse.Create createRoom(Long userId, RoomRequest.Create request) {

        request.getUsers()
                .add(userId);

        List<Map<String, Object>> users = new ArrayList<>();
        Room room = modelMapper.map(request, Room.class);
        roomRepository.save(room);

        for (Long id : request.getUsers()) {

            Map<String, Object> userInfo = new HashMap<>();
            User user = userRepository.findById(id).orElseThrow();
            UserRoom userRoom = UserRoom.builder()
                    .room(room)
                    .user(user)
                    .build();

            userInfo.put("userId", user.getId());
            userInfo.put("nickname", user.getNickname());
            userRoomRepository.save(userRoom);
            users.add(userInfo);
        }

        RoomResponse.Create response = modelMapper.map(room, RoomResponse.Create.class);

        response.setUserCount(userRoomRepository.countAllByRoom_Id(room.getId()));
        response.setDate(itemRepository.existsByRoom_IdAndItemType(room.getId(), ItemType.DATE));
        response.setTime(itemRepository.existsByRoom_IdAndItemType(room.getId(), ItemType.TIME));
        response.setLocation(itemRepository.existsByRoom_IdAndItemType(room.getId(), ItemType.LOCATION));
        response.setUsers(users);

        return response;
    }

    @Override
    public RoomResponse.Find findRoom(Long roomId) {

        List<UserRoom> userRooms = userRoomRepository.findAllByRoomId(roomId);
        Room room = roomRepository.findById(roomId).orElseThrow();
        RoomResponse.Find response = modelMapper.map(room, RoomResponse.Find.class);
        List<Map<String, Object>> users = new ArrayList<>();

        userRooms.forEach(userRoom -> {
            Map<String, Object> userInfo = new HashMap<>();
            User user = userRoom.getUser();
            userInfo.put("userId", user.getId());
            userInfo.put("nickname", user.getNickname());
            users.add(userInfo);
        });

        response.setDate(itemRepository.existsByRoom_IdAndItemType(roomId, ItemType.DATE));
        response.setTime(itemRepository.existsByRoom_IdAndItemType(roomId, ItemType.TIME));
        response.setLocation(itemRepository.existsByRoom_IdAndItemType(roomId, ItemType.LOCATION));
        response.setUsers(users);

        return response;
    }

    @Override
    public List<RoomResponse.FindAll> findAllRoom(Long userId) {

        List<UserRoom> userRooms = userRoomRepository.findAllByUserId(userId);
        List<RoomResponse.FindAll> response = new ArrayList<>();

        userRooms.forEach(userRoom -> response.add(modelMapper.map(userRoom.getRoom(), RoomResponse.FindAll.class)));
        return response;
    }

    @Override
    @Transactional
    public RoomResponse.Join joinRoom(Long userId, Long roomId) {

        User user = userRepository.findById(userId).orElseThrow();
        Room room = roomRepository.findById(roomId).orElseThrow();
        UserRoom userRoom = UserRoom.builder()
                .user(user)
                .room(room)
                .build();

        userRoomRepository.save(userRoom);

        List<UserRoom> userRooms = userRoomRepository.findAllByRoomId(roomId);
        RoomResponse.Join response = modelMapper.map(room, RoomResponse.Join.class);
        List<Map<String, Object>> users = new ArrayList<>();

        userRooms.forEach(ur -> {
            Map<String, Object> userInfo = new HashMap<>();
            User u = ur.getUser();
            userInfo.put("userId", u.getId());
            userInfo.put("nickname", u.getNickname());
            users.add(userInfo);
        });

        response.setDate(itemRepository.existsByRoom_IdAndItemType(roomId, ItemType.DATE));
        response.setTime(itemRepository.existsByRoom_IdAndItemType(roomId, ItemType.TIME));
        response.setLocation(itemRepository.existsByRoom_IdAndItemType(roomId, ItemType.LOCATION));
        response.setUsers(users);

        return response;
    }

    @Override
    @Transactional
    public List<RoomResponse.Exit> exitRoom(Long userId, Long roomId) {

        userRoomRepository.deleteByUserIdAndRoomId(userId, roomId);

        List<UserRoom> userRooms = userRoomRepository.findAllByUserId(userId);
        List<RoomResponse.Exit> response = new ArrayList<>();

        userRooms.forEach(userRoom -> response.add(modelMapper.map(userRoom.getRoom(), RoomResponse.Exit.class)));
        return response;
    }

    @Override
    @Transactional
    public void deleteRoom(Long roomId) {

        roomRepository.deleteById(roomId);
    }

    private boolean isComplete() {

        return true;
    }
}
