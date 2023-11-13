package com.wanyviny.promise.domain.item.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.wanyviny.promise.domain.alarm.ALARM_TYPE;
import com.wanyviny.promise.domain.alarm.entity.Alarm;
import com.wanyviny.promise.domain.alarm.repository.AlarmRepository;
import com.wanyviny.promise.domain.item.dto.ItemRequest;
import com.wanyviny.promise.domain.item.dto.ItemRequest.Create;
import com.wanyviny.promise.domain.item.dto.ItemResponse;
import com.wanyviny.promise.domain.item.dto.ItemResponse.Find;
import com.wanyviny.promise.domain.item.dto.ItemResponse.Modify;
import com.wanyviny.promise.domain.item.entity.Item;
import com.wanyviny.promise.domain.item.entity.ItemType;
import com.wanyviny.promise.domain.item.repository.ItemRepository;
import com.wanyviny.promise.domain.room.entity.Room;
import com.wanyviny.promise.domain.room.entity.UserRoom;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import com.wanyviny.promise.domain.room.repository.UserRoomRepository;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import com.wanyviny.promise.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ItemServiceImpl implements ItemService {

    private final ModelMapper modelMapper;
    private final ItemRepository itemRepository;
    private final RoomRepository roomRepository;
    private final UserRoomRepository userRoomRepository;
    private final AlarmRepository alarmRepository;
    private final FirebaseMessaging firebaseMessaging;

    @Override
    @Transactional
    public ItemResponse.Create createItem(Long userId, Long roomId, Create request) {

        Room room = roomRepository.findById(roomId).orElseThrow();

        room.setUserId(userId);
        room.setDeadDate(request.getDeadDate());
        room.setDeadTime(request.getDeadTime());
        room.setAnonymous(request.isAnonymous());
        room.setMultipleChoice(request.isMultipleChoice());


        ItemResponse.Create response = modelMapper.map(room, ItemResponse.Create.class);
        response.setUserCount(userRoomRepository.countAllByRoom_Id(room.getId()));

        if (request.getDate() != null) {

            request.getDate()
                    .forEach(date -> {
                        Item item = Item.builder()
                                .itemType(ItemType.DATE)
                                .date(date)
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setDate(true);
        }

        if (request.getTime() != null) {

            request.getTime()
                    .forEach(time -> {
                        Item item = Item.builder()
                                .itemType(ItemType.TIME)
                                .time(time)
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setTime(true);
        }

        if (request.getLocation() != null) {

            request.getLocation()
                    .forEach(location -> {
                        Item item = Item.builder()
                                .itemType(ItemType.LOCATION)
                                .location(location.get("location"))
                                .lat(location.get("lat"))
                                .lng(location.get("lng"))
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setLocation(true);
        }

        List<User> phondIdList = room.getUserRooms().stream()
                .map(UserRoom::getUser)
                .toList();

        String title = "CREATE VOTE!";
        String body = room.getPromiseTitle() + "에 투표가 추가되었습니다!";

        phondIdList.forEach(user -> {
            if (!Objects.equals(user.getId(), userId)) {
                String token = user.getPhoneId();
                createAlarm(user, body, ALARM_TYPE.CREATE_POLL);
                firebasePushAlarm(title, body, token);
            }
        });
        return response;
    }

    @Override
    public Find findItem(Long roomId) {

        List<Item> items = itemRepository.findAllByRoomId(roomId);
        Room room = roomRepository.findById(roomId).orElseThrow();
        ItemResponse.Find response = modelMapper.map(room, ItemResponse.Find.class);

        List<String> date = new ArrayList<>();
        List<String> time = new ArrayList<>();
        List<Map<String, String>> locations = new ArrayList<>();

        items.forEach(item -> {
            if (item.getItemType().equals(ItemType.DATE)) {

                date.add(item.getDate());

            } else if (item.getItemType().equals(ItemType.TIME)) {

                time.add(item.getTime());

            } else {

                Map<String, String> location = new HashMap<>();
                location.put("location", item.getLocation());
                location.put("lng", item.getLng());
                location.put("lat", item.getLat());
                locations.add(location);
            }
        });

        response.setDate(date);
        response.setTime(time);
        response.setLocation(locations);

        return response;
    }

    @Override
    @Transactional
    public Modify modifyItem(Long userId, Long roomId, ItemRequest.Modify request) {

        Room room = roomRepository.findById(roomId).orElseThrow();

        room.setUserId(userId);
        room.setDeadDate(request.getDeadDate());
        room.setDeadTime(request.getDeadTime());
        room.setAnonymous(request.isAnonymous());
        room.setMultipleChoice(request.isMultipleChoice());

        ItemResponse.Modify response = modelMapper.map(room, ItemResponse.Modify.class);
        response.setUserCount(userRoomRepository.countAllByRoom_Id(room.getId()));
        itemRepository.deleteAllByRoomId(roomId);

        if (request.getDate() != null) {

            request.getDate()
                    .forEach(date -> {
                        Item item = Item.builder()
                                .itemType(ItemType.DATE)
                                .date(date)
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setDate(true);

        }

        if (request.getTime() != null) {

            request.getTime()
                    .forEach(time -> {
                        Item item = Item.builder()
                                .itemType(ItemType.TIME)
                                .time(time)
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setTime(true);
        }

        if (request.getLocation() != null) {

            request.getLocation()
                    .forEach(location -> {
                        Item item = Item.builder()
                                .itemType(ItemType.LOCATION)
                                .location(location.get("location"))
                                .lat(location.get("lat"))
                                .lng(location.get("lng"))
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setLocation(true);
        }

        return response;
    }

    @Transactional
    public void firebasePushAlarm(String title, String Body, String token) {
        Notification notification = Notification.builder()
                .setTitle(title)
                .setBody(Body)
                .build();

        Message message = Message.builder()
                .setToken(token)  // 친구의 FCM 토큰 설정
                .setNotification(notification)
                .build();
        try {
            firebaseMessaging.send(message);
        } catch (FirebaseMessagingException e) {
            e.printStackTrace();
            throw new IllegalArgumentException("token에 해당하는 유저를 찾을 수 없습니다.");
        }
    }

    public void createAlarm(User user, String message, ALARM_TYPE type) {
        alarmRepository.save(Alarm.builder()
                .user(user)
                .alarmMessage(message)
                .alarmType(type)
                .build());
    }

    @Override
    @Transactional
    public void deleteItemType(Long roomId, ItemType itemType) {
        itemRepository.deleteAllByRoomIdAndItemType(roomId, itemType);
    }

    @Override
    @Transactional
    public void putItemType(Long roomId, ItemType itemType) {
        if (itemType == ItemType.DATE) {
            roomRepository.completeDate(roomId);
        } else if (itemType == ItemType.TIME) {
            roomRepository.completeTime(roomId);
        } else {
            roomRepository.completeLocation(roomId);
        }
    }
}