package com.wanyviny.room.domain.room.entity;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Room {

    @Id
    private String id;
    private List<Map<String, String>> users;
    private String promiseTitle;
    private String promiseDate;
    private String promiseTime;
    private String promiseLocation;
    private String defaultTitle;

    public void changeDefaultTitle() {
        StringBuilder sb = new StringBuilder();

        users.forEach(user -> sb.append(user.get("nickname")).append(", "));
        sb.setLength(sb.length() - 2);
        promiseTitle = sb.toString();
    }

    public void addUser(List<Map<String, String>> users) {

        this.users.addAll(users);
    }

    public void removeUser(String userId) {

        users = users.stream()
                .filter(user -> !user.get("userId").equals(userId))
                .collect(Collectors.toList());
    }
}
