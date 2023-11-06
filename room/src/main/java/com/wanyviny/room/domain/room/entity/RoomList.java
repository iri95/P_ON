package com.wanyviny.room.domain.room.entity;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
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
public class RoomList {

    @Id
    private String id;

    @Builder.Default
    private List<Map<String, String>> rooms = new ArrayList<>();

    public void addRoom(Map<String, String> room) {

        rooms.add(room);
    }

    public void removeRoom(String roomId) {

        rooms = rooms.stream()
                .filter(room -> !room.get("roomId").equals(roomId))
                .collect(Collectors.toList());
    }
}
