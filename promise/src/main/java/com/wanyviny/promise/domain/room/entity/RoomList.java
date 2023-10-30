package com.wanyviny.promise.domain.room.entity;

import com.wanyviny.promise.domain.room.vo.RoomVo;
import java.util.HashMap;
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
    private Map<String, RoomVo> rooms = new HashMap<>();

    public void addRoom(RoomVo roomVo) {
        rooms.put(roomVo.getRoomId(), roomVo);
    }
}
