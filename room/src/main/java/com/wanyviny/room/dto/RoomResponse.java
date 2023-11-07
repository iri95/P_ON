package com.wanyviny.room.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoomResponse {

    private String id;
    private List<Map<String, String>> users;
    private Map<String, Object> votes;
    private String promiseTitle;

    @Builder.Default
    private String promiseDate = "미정";

    @Builder.Default
    private String promiseTime = "미정";

    @Builder.Default
    private String promiseLocation = "미정";

    @Builder.Default
    private List<Map<String, Object>> chats = new ArrayList<>();

    public void changeDefaultTitle() {

        StringBuilder sb = new StringBuilder();

        users.forEach(user -> sb.append(user.get("nickname")).append(", "));
        sb.setLength(sb.length() - 2);

        promiseTitle = sb.toString();
    }
}
