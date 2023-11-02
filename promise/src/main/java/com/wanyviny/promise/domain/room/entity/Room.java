package com.wanyviny.promise.domain.room.entity;

import com.wanyviny.promise.domain.chat.entity.Chat;
import java.util.ArrayList;
import java.util.HashMap;
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
    private List<Map<String, String>> users;
    private String promiseTitle;
    private boolean isDefaultTitle;
    private String promiseDate;
    private String promiseTime;
    private String promiseLocation;

    @Builder.Default
    private List<Map<String, String>> chats = new ArrayList<>();

    public void changeIsDefaultTitle() {
        isDefaultTitle = !isDefaultTitle;
    }

    public void changeDefaultTitle() {
        StringBuilder sb = new StringBuilder();

        users.forEach(user -> {
            sb.append(user.get("nickname")).append(", ");
        });

        sb.setLength(sb.length() - 2);
        promiseTitle = sb.toString();
    }

    public void addUser(List<Map<String, String>> users) {
        this.users.addAll(users);
    }

    public void addChat(Chat chat) {
        Map<String, String> map = new HashMap<>();

        map.put("senderId", chat.getSenderId());
        map.put("sender", chat.getSender());
        map.put("chatType", String.valueOf(chat.getChatType()));
        map.put("content", chat.getContent());
        map.put("createAt", String.valueOf(chat.getCreateAt()));

        chats.add(map);
    }
}
