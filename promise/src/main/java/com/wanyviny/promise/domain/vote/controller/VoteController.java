package com.wanyviny.promise.domain.vote.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.vote.dto.VoteRequest;
import com.wanyviny.promise.domain.vote.dto.VoteResponse;
import com.wanyviny.promise.domain.vote.service.VoteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/vote")
@Tag(name = "투표", description = "투표 관련 API")
public class VoteController {

    private final VoteService voteService;

    @PostMapping("/{roomId}")
    @Operation(summary = "투표 생성", description = "약속 방 아이디에 해당하는 약속 방의 투표를 생성합니다.")
    public ResponseEntity<BasicResponse> createVote(
            @Parameter(description = "생성할 약속 방 아이디")
            @PathVariable String roomId,
            @RequestBody VoteRequest.CreateDto request
    ) {

        VoteResponse.CreateDto response = voteService.createVote(roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 생성 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/{voteId}")
    @Operation(summary = "투표 조회", description = "투표 아이디에 해당하는 투표를 조회합니다.")
    public ResponseEntity<BasicResponse> findVote(
            @Parameter(description = "조회할 투표 아이디")
            @PathVariable String voteId
    ) {

        VoteResponse.FindDto response = voteService.findVote(voteId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 조회 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
