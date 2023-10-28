package com.wanyviny.promise.room.entity;

import com.wanyviny.promise.room.vo.RoomVo;
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
    private List<RoomVo> rooms = new ArrayList<>();

    public void addRoom(RoomVo roomVo) {
        rooms.add(roomVo);
    }
}
