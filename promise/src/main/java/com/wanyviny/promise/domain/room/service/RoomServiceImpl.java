package com.wanyviny.promise.domain.room.service;

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
import com.wanyviny.promise.domain.chat.entity.Chat;
import com.wanyviny.promise.domain.chat.repository.ChatRepository;
import com.wanyviny.promise.domain.item.entity.Item;
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

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;

import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class RoomServiceImpl implements RoomService {

    private final ModelMapper modelMapper;
    private final RoomRepository roomRepository;
    private final UserRepository userRepository;
    private final UserRoomRepository userRoomRepository;
    private final ItemRepository itemRepository;
    private final AlarmRepository alarmRepository;
    private final ChatRepository chatRepository;
    private final CalendarRepository calendarRepository;
    private final FirebaseMessaging firebaseMessaging;


    @Override
    @Transactional
    public RoomResponse.Create createRoom(Long userId, RoomRequest.Create request) {
        User inviter = userRepository.findById(userId).orElseThrow(
                () -> new IllegalArgumentException("해당하는 유저가 없습니다.")
        );
        request.getUsers()
                .add(userId);

        List<Map<String, Object>> users = new ArrayList<>();
        Room room = modelMapper.map(request, Room.class);
        roomRepository.save(room);
        if (!room.getPromiseDate().equals("미정")) {
            roomRepository.completeDate(room.getId());
        }
        if (!room.getPromiseTime().equals("미정")) {
            roomRepository.completeTime(room.getId());
        }

        if (!room.getPromiseLocation().equals("미정")) {
            roomRepository.completeLocation(room.getId());
        }

        if (!room.getPromiseLocation().equals("미정") && !room.getPromiseDate().equals("미정") && !room.getPromiseTime().equals("미정")) {
            roomRepository.completeRoom(room.getId());
            createPromiseToCalendar(room, request.getUsers());
        }

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

            if (Objects.equals(user.getId(), userId)) continue;
            String title = "INVITE!";
            String body = inviter.getNickname() + "님께서 약속방에 초대하셨습니다!";
            String token = user.getPhoneId();

            createAlarm(user, body, ALARM_TYPE.INVITE);
            firebasePushAlarm(title, body, token);

        }

        RoomResponse.Create response = modelMapper.map(room, RoomResponse.Create.class);

        response.setUserCount(userRoomRepository.countAllByRoom_Id(room.getId()));
        response.setDate(itemRepository.existsByRoom_IdAndItemType(room.getId(), ItemType.DATE));
        response.setTime(itemRepository.existsByRoom_IdAndItemType(room.getId(), ItemType.TIME));
        response.setLocation(itemRepository.existsByRoom_IdAndItemType(room.getId(), ItemType.LOCATION));
        boolean complete = isComplete(room.getDeadDate(), room.getDeadTime());
        response.setDateComplete(complete);
        response.setTimeComplete(complete);
        response.setLocationComplete(complete);
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
            userInfo.put("profileImage", user.getProfileImage());
            users.add(userInfo);
        });

        response.setDate(itemRepository.existsByRoom_IdAndItemType(roomId, ItemType.DATE));
        response.setTime(itemRepository.existsByRoom_IdAndItemType(roomId, ItemType.TIME));
        response.setLocation(itemRepository.existsByRoom_IdAndItemType(roomId, ItemType.LOCATION));
        boolean complete = isComplete(room.getDeadDate(), room.getDeadTime());
        response.setDateComplete(complete);
        response.setTimeComplete(complete);
        response.setLocationComplete(complete);
        response.setUsers(users);

        return response;
    }

    @Override
    public List<RoomResponse.FindAll> findAllRoom(Long userId, boolean complete) {

        List<UserRoom> userRooms = userRoomRepository.findAllByUserId(userId);
        List<RoomResponse.FindAll> response = new ArrayList<>();

        userRooms.forEach(userRoom -> {
            List<String> lastChatIdList = chatRepository.findAllByRoomId(String.valueOf(userRoom.getRoom().getId())).stream()
                    .sorted(((o1, o2) -> {
                        if (o1.getCreateAt().isAfter(o2.getCreateAt())) return -1;
                        else if (o1.getCreateAt().isEqual(o2.getCreateAt())) return 0;
                        else return 1;
                    })).map(Chat::getId).toList();
            Room room = userRoom.getRoom();
            if (room.isComplete() == complete) {
                if (lastChatIdList.size() != 0) {
                    String lastChatId = lastChatIdList.get(0);
                    String userChatId = userRoom.getChatId();
                    if (userChatId != null) {
                        response.add(RoomResponse.FindAll.builder()
                                .id(room.getId())
                                .promiseTitle(room.getPromiseTitle())
                                .promiseDate(room.getPromiseDate())
                                .promiseTime(room.getPromiseTime())
                                .promiseLocation(room.getPromiseLocation())
                                .read(userChatId.equals(lastChatId))
                                .build());
                    } else {
                        response.add(RoomResponse.FindAll.builder()
                                .id(room.getId())
                                .promiseTitle(room.getPromiseTitle())
                                .promiseDate(room.getPromiseDate())
                                .promiseTime(room.getPromiseTime())
                                .promiseLocation(room.getPromiseLocation())
                                .read(false)
                                .build());
                    }
                } else {
                    response.add(RoomResponse.FindAll.builder()
                            .id(room.getId())
                            .promiseTitle(room.getPromiseTitle())
                            .promiseDate(room.getPromiseDate())
                            .promiseTime(room.getPromiseTime())
                            .promiseLocation(room.getPromiseLocation())
                            .read(true)
                            .build());
                }
            }
        });
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
        boolean complete = isComplete(room.getDeadDate(), room.getDeadTime());
        response.setDateComplete(complete);
        response.setTimeComplete(complete);
        response.setLocationComplete(complete);
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

    @Override
    @Transactional
    public void completePromise(Long roomId) {
        roomRepository.completePromise(roomId);
    }

    private boolean isComplete(String deadDate, String deadTime) {

        if (deadDate == null) {
            return false;
        }

        String date = deadDate.substring(0, 10);
        String time = deadTime.substring(3);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH시 mm분");
        LocalDateTime localDateTime = LocalDateTime.parse(date + " " + time, formatter);

        if (deadTime.startsWith("오후")) {

            localDateTime = localDateTime.plusHours(12);
        }

//        return localDateTime.compareTo(LocalDateTime.now()) > 0 ? false : true;
        return !localDateTime.isAfter(LocalDateTime.now());
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

    public void createPromiseToCalendar(Room room, List<Long> users) {
        String date = room.getPromiseDate().substring(0, 10);
        String time = room.getPromiseTime().substring(3);
        String location = room.getPromiseLocation();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH시 mm분");
        LocalDateTime localDateStartTime = LocalDateTime.parse(date + " " + time, formatter);
        LocalDateTime localDateEndTime = LocalDateTime.parse(date + " 23시 59분", formatter);

        if (time.startsWith("오후")) {
            localDateStartTime = localDateStartTime.plusHours(12);
        }

        Date startDate = Date.from(localDateStartTime.atZone(ZoneId.systemDefault()).toInstant());
        Date endDate = Date.from(localDateEndTime.atZone(ZoneId.systemDefault()).toInstant());

        users.stream().map(userId -> {
            return userRepository.findById(userId).orElseThrow(
                    () -> new IllegalArgumentException("해당 유저가 존재하지 않습니다.")
            );
        }).toList().forEach(user -> {
            calendarRepository.save(Calendar.builder()
                    .userId(user)
                    .title(room.getPromiseTitle())
                    .place(location)
                    .startDate(startDate)
                    .endDate(endDate)
                    .type(CALENDAR_TYPE.PROMISE)
                    .build());
        });
    }


}
