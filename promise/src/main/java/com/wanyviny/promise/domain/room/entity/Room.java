package com.wanyviny.promise.domain.room.entity;

import com.wanyviny.promise.domain.chat.entity.Chat;
import com.wanyviny.promise.domain.vote.entity.Vote;
import com.wanyviny.promise.domain.vote.entity.VoteType;
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

    @Builder.Default
    private List<Map<String, String>> votes = defaultVotes();

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

    private static List<Map<String, String>> defaultVotes() {
        List<Map<String, String>> votes = new ArrayList<>();
        VoteType[] voteTypes = VoteType.values();

        for (VoteType voteType : voteTypes) {
            Map<String, String> map = new HashMap<>();
            map.put("voteType", String.valueOf(voteType));
            map.put("exist", "false");
            votes.add(map);;
        }

        return votes;
    }

    public void addVote(Vote vote) {

        for (Map<String, String> map : votes) {
            if (map.get("voteType").equals(String.valueOf(vote.getVoteType()))) {
                map.put("exist", "true");
                map.put("voteId", vote.getId());
                break;
            }
        }
    }
}
