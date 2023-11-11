package com.wanyviny.promise.domain.vote.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.vote.dto.VoteDto;
import com.wanyviny.promise.domain.vote.service.VoteService;
import com.wanyviny.promise.domain.vote.service.VoteServiceImpl;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/vote")
@Tag(name = "투표", description = "투표 관련 API")
public class VoteController {

    private final VoteService voteService;

    // 사용자 투표 하기
    @PostMapping("/")
    @Operation(summary = "투표 하기", description = "사용자가 항목에 투표합니다. 헤더 필요!")
    public ResponseEntity<BasicResponse> postVote(@RequestHeader("id") Long userId, @RequestBody VoteDto.post post) {
        voteService.postVote(userId, post);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 완료")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 채팅방 투표의 항목별 투표수 조회 ( 전체 ) -> 누가 투표했는지  포함
    @GetMapping("/{roomId}")
    public ResponseEntity<BasicResponse> getItemVote(@PathVariable(name = "roomId") Long roomId) {


        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 완료")
//                .count(1)
//                .result(Collections.singletonList())
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 해당 항목에 투표한 사람 조회 -> item id 필요
    @GetMapping("/Item/{ItemId}")
    public ResponseEntity<BasicResponse> getItemVoteUser(@PathVariable(name = "ItemId") Long ItemId) {


        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 완료")
//                .count(1)
//                .result(Collections.singletonList())
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 사용자 투표 수정
    @PutMapping("/{roomId}")
    public ResponseEntity<BasicResponse> putVote(@RequestHeader("id") Long userId, @PathVariable(name = "roomId") Long roomId, @RequestBody VoteDto.put put) {


        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 완료")
//                .count(1)
//                .result(Collections.singletonList())
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

}
