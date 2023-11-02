package com.wanyviny.promise.domain.room.entity;

import com.wanyviny.promise.domain.room.vo.RoomVo;
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
public class RoomList {

    @Id
    private String id;

    @Builder.Default
    private List<Map<String, String>> rooms = new ArrayList<>();

    public void addRoom(RoomVo roomVo) {

        Map<String, String> map = new HashMap<>();

        map.put("roomId", roomVo.getRoomId());
        map.put("promiseTitle", roomVo.getPromiseTitle());
        map.put("promiseDate", roomVo.getPromiseDate());
        map.put("promiseTime", roomVo.getPromiseTime());
        map.put("promiseLocation", roomVo.getPromiseLocation());
        map.put("unread", String.valueOf(roomVo.isUnread()));

        rooms.add(map);
    }
}
