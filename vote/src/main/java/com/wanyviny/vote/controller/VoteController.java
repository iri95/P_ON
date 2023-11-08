package com.wanyviny.vote.controller;

import com.wanyviny.vote.common.BasicResponse;
import com.wanyviny.vote.dto.VoteRequest;
import com.wanyviny.vote.dto.VoteResponse;
import com.wanyviny.vote.service.VoteService;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "투표", description = "투표 관련 API")
public class VoteController {

    private final VoteService voteService;

    @PostMapping("/api/vote/{roomId}")
    public ResponseEntity<BasicResponse> createVote(
            @RequestHeader("id") String userId,
            @PathVariable String roomId,
            @RequestBody VoteRequest request
    ) {

        voteService.createVote(userId, roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 생성 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/api/vote/{roomId}")
    public ResponseEntity<BasicResponse> findVote(@PathVariable String roomId) {

        VoteResponse response = voteService.findVote(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 조회 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/api/vote/{roomId}")
    public ResponseEntity<BasicResponse> modifyVote(
            @RequestHeader("id") String userId,
            @PathVariable String roomId,
            @RequestBody VoteRequest request
    ) {

        voteService.modifyVote(userId, roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 수정 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
