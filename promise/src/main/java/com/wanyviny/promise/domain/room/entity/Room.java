package com.wanyviny.promise.domain.room.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.wanyviny.promise.domain.item.entity.Item;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.util.List;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Entity
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "ROOM")
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ROOM_ID")
    private Long id;

    private String promiseTitle;
    private String promiseDate;
    private String promiseTime;
    private String promiseLocation;

    private Long userId;
    private boolean isComplete;
    private boolean isAnonymous;
    private boolean isMultipleChoice;
    private String deadDate;
    private String deadTime;

    @JsonIgnore
    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "room")
    private List<UserRoom> userRooms;

//    @JsonIgnore
//    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "room")
//    private List<Poll> poll;

    @JsonIgnore
    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "room")
    private List<Item> items;

//    @Builder.Default
//    private List<Map<String, String>> chats = new ArrayList<>();
//
//    @Builder.Default
//    private List<Map<String, String>> votes = defaultVotes();

//    public void changeIsDefaultTitle() {
//        isDefaultTitle = !isDefaultTitle;
//    }
//
//    public void changeDefaultTitle() {
//        StringBuilder sb = new StringBuilder();
//
//        users.forEach(user -> {
//            sb.append(user.get("nickname")).append(", ");
//        });
//
//        sb.setLength(sb.length() - 2);
//        promiseTitle = sb.toString();
//    }
//
//    public void addUser(List<Map<String, String>> users) {
//        this.users.addAll(users);
//    }
//
//    public void addChat(Chat chat) {
//        Map<String, String> map = new HashMap<>();
//
//        map.put("senderId", chat.getSenderId());
//        map.put("sender", chat.getSender());
//        map.put("chatType", String.valueOf(chat.getChatType()));
//        map.put("content", chat.getContent());
//        map.put("createAt", String.valueOf(chat.getCreateAt()));
//
//        chats.add(map);
//    }
//
//    private static List<Map<String, String>> defaultVotes() {
//        List<Map<String, String>> votes = new ArrayList<>();
//        VoteType[] voteTypes = VoteType.values();
//
//        for (VoteType voteType : voteTypes) {
//            Map<String, String> map = new HashMap<>();
//            map.put("voteType", String.valueOf(voteType));
//            map.put("exist", "false");
//            votes.add(map);;
//        }
//
//        return votes;
//    }
//
//    public void addVote(Vote vote) {
//
//        for (Map<String, String> map : votes) {
//            if (map.get("voteType").equals(String.valueOf(vote.getVoteType()))) {
//                map.put("exist", "true");
//                map.put("voteId", vote.getId());
//                break;
//            }
//        }
//    }
}
