package com.wanyviny.promise.room.entity;

import com.wanyviny.promise.message.entity.Message;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collation = "room")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Room {

    private String promiseTitle;
    private String promiseDate;
    private String promiseTime;
    private String promiseLocation;
    private boolean unread;

    private List<Message> messages;

    public void read() {
        unread = false;
    }

    public void unread() {
        unread = true;
    }

    public void addMessage(Message message) {
        messages.add(message);
    }
}
