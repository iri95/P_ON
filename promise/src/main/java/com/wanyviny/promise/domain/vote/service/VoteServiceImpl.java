package com.wanyviny.promise.domain.vote.service;

import com.wanyviny.promise.domain.room.entity.Room;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import com.wanyviny.promise.domain.vote.dto.VoteRequest;
import com.wanyviny.promise.domain.vote.dto.VoteResponse;
import com.wanyviny.promise.domain.vote.entity.Vote;
import com.wanyviny.promise.domain.vote.repository.VoteRepository;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class VoteServiceImpl implements VoteService {

    private final VoteRepository voteRepository;
    private final RoomRepository roomRepository;

    @Override
    public VoteResponse.CreateDto createVote(String roomId, VoteRequest.CreateDto request) {

        Vote vote = Vote.builder()
                .voteType(request.voteType())
                .title(request.title())
                .deadLine(LocalDateTime.now())
                .items(request.items())
                .build();

        voteRepository.save(vote);

        Room room = roomRepository.findById(roomId).orElseThrow();
        room.addVote(vote);
        roomRepository.save(room);

        return VoteResponse.CreateDto
                .builder()
                .voteType(vote.getVoteType())
                .title(vote.getTitle())
                .deadLine(vote.getDeadLine())
                .items(vote.getItems())
                .build();
    }
}
