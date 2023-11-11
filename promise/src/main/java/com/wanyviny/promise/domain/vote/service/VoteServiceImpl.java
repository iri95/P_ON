package com.wanyviny.promise.domain.vote.service;

import com.wanyviny.promise.domain.item.repository.ItemRepository;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import com.wanyviny.promise.domain.user.entity.User;
import com.wanyviny.promise.domain.user.repository.UserRepository;
import com.wanyviny.promise.domain.vote.dto.VoteDto;
import com.wanyviny.promise.domain.vote.entity.Vote;
import com.wanyviny.promise.domain.vote.repository.VoteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
}
