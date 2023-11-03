package com.wanyviny.promise.domain.vote.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.vote.dto.VoteRequest;
import com.wanyviny.promise.domain.vote.dto.VoteResponse;
import com.wanyviny.promise.domain.vote.service.VoteService;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/vote")
public class VoteController {

    private final VoteService voteService;

    @PostMapping("/{roomId}")
    public ResponseEntity<BasicResponse> createVote(
            @PathVariable String roomId,
            VoteRequest.CreateDto request
    ) {

        VoteResponse.CreateDto response = voteService.createVote(roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 생성 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
