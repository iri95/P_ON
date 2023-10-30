package com.wanyviny.promise.domain.room.entity;

import com.wanyviny.promise.chat.entity.Chat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
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

    private Map<String, String> users;
    private String promiseTitle;
    private boolean isDefaultTitle;
    private String promiseDate;
    private String promiseTime;
    private String promiseLocation;

    @Builder.Default
    private List<Chat> chats = new ArrayList<>();

    public void changeIsDefaultTitle() {
        isDefaultTitle = !isDefaultTitle;
    }

    public void changeDefaultTitle() {
        StringBuilder sb = new StringBuilder();

        users.forEach((k, v) -> {
            sb.append(v).append(", ");
        });

        sb.setLength(sb.length() - 2);
        promiseTitle = sb.toString();
    }

    public void addUser(Map<String, String> users) {
        this.users.putAll(users);
    }

    public void addChat(Chat chat) {
        chats.add(chat);
    }
}
