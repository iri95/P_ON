package com.wanyviny.chat;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.wanyviny.chat.dto.ChatRequest;
import com.wanyviny.chat.dto.ChatResponse;
import com.wanyviny.chat.entity.*;
import com.wanyviny.chat.repository.RoomRepository;
import com.wanyviny.chat.repository.UserRepository;
import com.wanyviny.chat.service.ChatService;
import org.junit.jupiter.api.Test;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.data.redis.core.RedisTemplate;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@SpringBootTest
class ChatApplicationTests {
    @Autowired
    private ChatService chatService;
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    @Autowired
    private FirebaseMessaging firebaseMessaging;

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ModelMapper modelMapper;

    @BeforeEach
    public void setup() {
        chatService = new ChatService() {
            @Override
            public ChatResponse.SendDto sendChat(ChatRequest.SendDto request) {

                User createdUser = User.builder()
                        .phoneId("123123123")
                        .id(2L)
                        .role(ROLE.USER)
                        .nickname("이상훈")
                        .profileImage("/images/profile/default.png")
                        .socialId("12323231223")
                        .phoneId("01bb24f625671854")
                        .build();

                userRepository.save(createdUser);

                List<User> list = new ArrayList<>();

                list.add(createdUser);

                Room room1 = Room.builder()
                        .id(1L)
                        .userList(list)
                        .build();

                roomRepository.save(room1);

                Chat chat = Chat.builder()
                        .chatType(request.getChatType())
                        .createAt(LocalDateTime.now())
                        .content(request.getContent())
                        .sender(request.getSender())
                        .id("1")
                        .roomId(request.getRoomId())
                        .senderId(request.getSenderId())
                        .senderProfile(request.getSenderProfile())
                        .build();

                Notification notification = Notification.builder()
                        .setTitle(chat.getSender())
                        .setBody(chat.getContent())
                        .setImage(chat.getSenderProfile())
                        .build();

                Long roomId = Long.parseLong(chat.getRoomId());
                System.out.println(roomId);

                Room room = roomRepository.findById(roomId).orElseThrow(
                        () -> new IllegalArgumentException("해당 약속방이 없습니다.")
                );

                List<String> userPhoneIdList = room1.getUserList().stream()
                        .filter(user -> !chat.getSenderId().equals(String.valueOf(user.getId())))
                        .map(User::getPhoneId)
                        .filter(phoneId -> phoneId.length() != 0)
                        .toList();

                List<Message> messageList = new ArrayList<>();
                for (String phoneId : userPhoneIdList
                ) {
                    messageList.add(Message.builder()
                            .setToken(phoneId)  // 친구의 FCM 토큰 설정
                            .setNotification(notification)
                            .build());
                }

                Message msg = Message.builder()
                        .setToken("01bb24f625671854")
                        .setNotification(notification)
                        .build();

                try {
                    firebaseMessaging.sendAll(messageList);
                    firebaseMessaging.send(msg);
                } catch (FirebaseMessagingException e) {
                    e.printStackTrace();
                    throw new IllegalArgumentException("알림을 보낼 유저를 찾을 수 없습니다.");
                }

                return modelMapper.map(chat, ChatResponse.SendDto.class);
            }

            @Override
            public ChatResponse.FindDto findChat(String roomId, String chatId) {
                return null;
            }

            @Override
            public ChatResponse.FindAllDto findAllChat(String roomId) {
                return null;
            }

            @Override
            public void deleteChats(String roomId) {

            }
        };
    }

    @Test
    public void testSendChat() {
        // Arrange
        ChatRequest.SendDto request = ChatRequest.SendDto.builder()
                .roomId("1")
                .content("안녕안녕 test")
                .chatType(ChatType.ENTER)
                .sender("이상훈")
                .senderProfile("/images/profile/default.png")
                .senderId("1")
                .build();

        // Act
        ChatResponse.SendDto result = chatService.sendChat(request);

        // Assert
        assertNotNull(result);
        // Add more assertions as needed to verify the behavior
    }

    @Test
    void contextLoads() {
    }

}
