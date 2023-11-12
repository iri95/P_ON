package com.wanyviny.promise.domain.vote.service;

import com.wanyviny.promise.domain.item.entity.Item;
import com.wanyviny.promise.domain.item.entity.ItemType;
import com.wanyviny.promise.domain.item.repository.ItemRepository;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import com.wanyviny.promise.domain.user.entity.User;
import com.wanyviny.promise.domain.user.repository.UserRepository;
import com.wanyviny.promise.domain.vote.dto.VoteDto;
import com.wanyviny.promise.domain.vote.entity.Vote;
import com.wanyviny.promise.domain.vote.repository.VoteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

@Service
@RequiredArgsConstructor
public class VoteServiceImpl implements VoteService {

    private final VoteRepository voteRepository;
    private final UserRepository userRepository;
    private final RoomRepository roomRepository;
    private final ItemRepository itemRepository;

    @Override
    public void postVote(Long userId, VoteDto.post post) {
        User user = userRepository.findById(userId).orElseThrow(
                () -> new IllegalArgumentException("해당 유저가 없습니다.")
        );
        post.getItemList().forEach(
                itemId -> voteRepository.save(Vote.builder()
                        .user(user)
                        .item(itemRepository.findById(itemId).orElseThrow(
                                () -> new IllegalArgumentException("해당 항목이 없습니다.")
                        ))
                        .build()));
    }

    @Override
    public VoteDto.get getVote(Long userId, Long roomId) {
        List<Item> itemList = itemRepository.findAllByRoomId(roomId);
        List<VoteDto.get.getDate> getDates = new ArrayList<>();
        List<VoteDto.get.getTime> getTimes = new ArrayList<>();
        List<VoteDto.get.getLocation> getLocations = new ArrayList<>();
        AtomicBoolean doDate = new AtomicBoolean(false);
        AtomicBoolean doTime = new AtomicBoolean(false);
        AtomicBoolean doLocation = new AtomicBoolean(false);

        itemList.forEach(item -> {
            if (item.getItemType() == ItemType.DATE) {
                doDate.set(item.getVotes().stream().map(Vote::getUser).map(User::getId).toList().contains(userId));
                getDates.add(item.entityToDate());
            } else if (item.getItemType() == ItemType.TIME) {
                doTime.set(item.getVotes().stream().map(Vote::getUser).map(User::getId).toList().contains(userId));
                getTimes.add(item.entityToTime());
            } else {
                doLocation.set(item.getVotes().stream().map(Vote::getUser).map(User::getId).toList().contains(userId));
                getLocations.add(item.entityToLocation());
            }
        });

        return VoteDto.get.builder()
                .doDate(doDate.get())
                .doTime(doTime.get())
                .doLocation(doLocation.get())
                .dates(getDates)
                .times(getTimes)
                .locations(getLocations)
                .build();
    }

    @Override
    public List<String> getUserList(Long itemId) {

        return voteRepository.findVote_User_NickNameByItemId(itemId);
    }


    @Override
    public void updateVote(Long userId, VoteDto.put put) {
        voteRepository.deleteByUser_IdAndItem_TypeAndRoom_Id(userId, put.getItemType(), put.getRoomId());

        User user = userRepository.findById(userId).orElseThrow(
                () -> new IllegalArgumentException("해당 유저가 없습니다.")
        );

        put.getItemList().forEach(
                itemId -> voteRepository.save(Vote.builder()
                        .user(user)
                        .item(itemRepository.findById(itemId).orElseThrow(
                                () -> new IllegalArgumentException("해당 항목이 없습니다.")
                        ))
                        .build()));
    }


}
