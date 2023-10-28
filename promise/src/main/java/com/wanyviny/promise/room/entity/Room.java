package com.wanyviny.promise.room.entity;

import com.wanyviny.promise.chat.entity.Chat;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Room {

    @Id
    private String id;

    private String promiseTitle;
    private String promiseDate;
    private String promiseTime;
    private String promiseLocation;

    @Builder.Default
    private List<String> users = new ArrayList<>();

    @Builder.Default
    private List<Chat> chats = new ArrayList<>();

    public void addUser(String userId) {
        users.add(userId);
    }

    public void addChat(Chat chat) {
        chats.add(chat);
    }
}
