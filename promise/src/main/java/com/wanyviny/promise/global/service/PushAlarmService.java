package com.wanyviny.promise.global.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.wanyviny.promise.domain.alarm.ALARM_TYPE;
import com.wanyviny.promise.domain.alarm.entity.Alarm;
import com.wanyviny.promise.domain.alarm.repository.AlarmRepository;
import com.wanyviny.promise.domain.item.entity.ItemType;
import com.wanyviny.promise.domain.item.service.ItemService;
import com.wanyviny.promise.domain.item.service.ItemServiceImpl;
import com.wanyviny.promise.domain.room.entity.Room;
import com.wanyviny.promise.domain.room.entity.UserRoom;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import com.wanyviny.promise.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@EnableScheduling
@Service
@RequiredArgsConstructor
public class PushAlarmService {
    private final FirebaseMessaging firebaseMessaging;
    private final AlarmRepository alarmRepository;
    private final RoomRepository roomRepository;
    private final ItemServiceImpl itemService;

    @Scheduled(cron = "1 0/10 * * * *")
    @Transactional
    public void voteComplete() {
        List<Room> roomList = roomRepository.findByDateCompleteIsOrTimeCompleteIsOrLocationCompleteIs(false, false, false);
        String title = "VOTE END!";

        roomList.forEach(room -> {
            if (isComplete(room.getDeadDate(), room.getDeadTime(), 0L)) {
                String message = room.getPromiseTitle() + "의 투표가 종료되었습니다!";
                roomRepository.completeRoom(room.getId());
                if (itemService.promiseVoteComplete(room, ItemType.DATE)
                        && itemService.promiseVoteComplete(room, ItemType.TIME)
                        && itemService.promiseVoteComplete(room, ItemType.LOCATION)) {
                    itemService.promiseToCalendar(room);
                    alarm(room, title, message, ALARM_TYPE.END_POLL);
                }
            }
        });

    }

    @Scheduled(cron = "1 0/10 * * * *")
    @Transactional
    public void promiseAhead() {
        List<Room> roomList = roomRepository.findByDateCompleteIsOrTimeCompleteIsOrLocationCompleteIs(false, false, false);
        String title = "PROMISE AHEAD!";

        roomList.forEach(room -> {
            if (room.isDateComplete() && room.isTimeComplete() &&
                    isComplete(room.getPromiseDate(), room.getPromiseTime(), 1L)) {
                String message = room.getPromiseTitle() + "가 1시간 남았습니다!";
                alarm(room, title, message, ALARM_TYPE.AHEAD_PROMISE);
            }
        });
    }

    private boolean isComplete(String deadDate, String deadTime, Long minusHours) {

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

        localDateTime = localDateTime.minusHours(minusHours);

        return !localDateTime.isAfter(LocalDateTime.now());
    }


    @Transactional
    public void alarm(Room room, String title, String message, ALARM_TYPE type) {
        List<User> userList = room.getUserRooms().stream()
                .map(UserRoom::getUser)
                .toList();

        userList.forEach(user -> {
            createAlarm(user, message, type);
            firebasePushAlarm(title, message, user.getPhoneId());
        });
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
}
