package com.wanyviny.calendar.global.kafka.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.wanyviny.calendar.domain.calendar.service.CalendarService;
import com.wanyviny.calendar.domain.user.repository.UserRepository;
import com.wanyviny.calendar.global.kafka.dto.KafkaCalendarDto;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;

@Service
@RequiredArgsConstructor
public class KafkaConsumerService {

    private final CalendarService calendarService;
    private final UserRepository userRepository;
    private final FirebaseMessaging firebaseMessaging;

    @Transactional
    @KafkaListener(topics = "from-chatbot-json", groupId = "calendar", containerFactory = "kafkaListener")
    public void consume(KafkaCalendarDto dto) throws ParseException {
        if (dto.getCal() == null) {
            return;
        }
        calendarService.postSchedule(dto.getUserId(), dto.kafkaToSet());

        String title = "CREATE CALENDAR";
        String body = dto.getCal().getCalendar_title() + " 일정이 생성되었습니다!!";
        String token = userRepository.findById(dto.getUserId()).orElseThrow(
                () -> new IllegalArgumentException("해당 유저가 존재하지 않습니다.")
        ).getPhoneId();

        firebasePushAlarm(title, body, token);

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
}