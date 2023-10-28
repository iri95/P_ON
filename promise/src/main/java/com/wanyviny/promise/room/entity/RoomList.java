package com.wanyviny.promise.room.entity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
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
    private String userId;

    @Builder.Default
    private List<Map<String, Room>> rooms = new ArrayList<>();

    public void addRoom(Room room) {
        Map<String, Room> roomMap = new HashMap<>();
        roomMap.put(String.valueOf(UUID.randomUUID()), room);
        rooms.add(roomMap);
    }
}
