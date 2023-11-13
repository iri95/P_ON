package com.wanyviny.promise.domain.item.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.wanyviny.promise.domain.alarm.ALARM_TYPE;
import com.wanyviny.promise.domain.alarm.entity.Alarm;
import com.wanyviny.promise.domain.alarm.repository.AlarmRepository;
import com.wanyviny.promise.domain.calendar.entity.CALENDAR_TYPE;
import com.wanyviny.promise.domain.calendar.entity.Calendar;
import com.wanyviny.promise.domain.calendar.repository.CalendarRepository;
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
import java.time.ZoneId;
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
    private final CalendarRepository calendarRepository;
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
        Room room = roomRepository.findById(roomId).orElseThrow(
                () -> new IllegalArgumentException("해당 약속방이 존재하지 않습니다.")
        );

        // Transactional로 인해? -> roomRepository.completeDate가 바로 반영되지 않아
        // 마지막에 세개가 모두 complete라는 if문이 작동하지 않음.
        if (promiseVoteComplete(room, itemType)) {
            if (itemType == ItemType.DATE) {
                roomRepository.completeDate(roomId);
                if (room.isTimeComplete() && room.isLocationComplete()) {
                    promiseToCalendar(room);
                }
            } else if (itemType == ItemType.TIME) {
                roomRepository.completeTime(roomId);
                if (room.isDateComplete() && room.isLocationComplete()) {
                    promiseToCalendar(room);
                }
            } else {
                roomRepository.completeLocation(roomId);
                if (room.isDateComplete() && room.isTimeComplete()) {
                    promiseToCalendar(room);
                }
            }
        } else {
            throw new IllegalArgumentException("해당 타입의 투표 항목이 존재하지 않습니다.");
        }
    }

    public boolean promiseVoteComplete(Room room, ItemType itemType) {
        List<Item> itemList = room.getItems().stream()
                .filter(item -> item.getItemType() == itemType)
                .sorted((o1, o2) -> Integer.compare(o2.getVotes().size(), o1.getVotes().size()))
                .toList();

        if (itemList.size() == 0) return false;

        if (itemType == ItemType.DATE) {
            room.setPromiseDate(itemList.get(0).getDate());
        } else if (itemType == ItemType.TIME) {
            room.setPromiseTime(itemList.get(0).getTime());
        } else {
            room.setPromiseLocation(itemList.get(0).getLocation());
        }
        return true;
    }

    public void promiseToCalendar(Room room) {
        Item dateItem = room.getItems().stream()
                .filter(item -> item.getItemType() == ItemType.DATE)
                .sorted((o1, o2) -> Integer.compare(o2.getVotes().size(), o1.getVotes().size()))
                .toList().get(0);
        Item timeItem = room.getItems().stream()
                .filter(item -> item.getItemType() == ItemType.TIME)
                .sorted((o1, o2) -> Integer.compare(o2.getVotes().size(), o1.getVotes().size()))
                .toList().get(0);
        Item locationItem = room.getItems().stream()
                .filter(item -> item.getItemType() == ItemType.LOCATION)
                .sorted((o1, o2) -> Integer.compare(o2.getVotes().size(), o1.getVotes().size()))
                .toList().get(0);

        String date = dateItem.getDate().substring(0, 10);
        String time = timeItem.getTime().substring(3);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH시 mm분");
        LocalDateTime localDateStartTime = LocalDateTime.parse(date + " " + time, formatter);
        LocalDateTime localDateEndTime = LocalDateTime.parse(date + " 23시 59분", formatter);

        if (time.startsWith("오후")) {
            localDateStartTime = localDateStartTime.plusHours(12);
        }

        Date startDate = Date.from(localDateStartTime.atZone(ZoneId.systemDefault()).toInstant());
        Date endDate = Date.from(localDateEndTime.atZone(ZoneId.systemDefault()).toInstant());

        room.getUserRooms().stream().map(UserRoom::getUser).forEach(user -> {
            calendarRepository.save(Calendar.builder()
                    .userId(user)
                    .title(room.getPromiseTitle())
                    .place(locationItem.getLocation())
                    .startDate(startDate)
                    .endDate(endDate)
                    .type(CALENDAR_TYPE.PROMISE)
                    .build());
        });
    }
}