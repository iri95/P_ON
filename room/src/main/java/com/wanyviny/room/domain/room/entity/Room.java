package com.wanyviny.room.domain.room.entity;

import java.util.HashMap;
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
import org.springframework.util.StringUtils;

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
    private Map<String, Object> votes;

    public void defaultVotes() {

        this.votes = new HashMap<>();

        votes.put("date", StringUtils.hasText(promiseDate));
        votes.put("time", StringUtils.hasText(promiseTime));
        votes.put("location", StringUtils.hasText(promiseLocation));
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
