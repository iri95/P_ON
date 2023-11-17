package com.wanyviny.promise.domain.vote.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.room.repository.UserRoomRepository;
import com.wanyviny.promise.domain.user.entity.User;
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
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/vote")
@Tag(name = "투표", description = "투표 관련 API")
public class VoteController {

    private final VoteService voteService;
    private final UserRoomRepository userRoomRepository;

    // 사용자 투표 하기
    @PostMapping("")
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
    @Operation(summary = "투표 현황 조회", description = "투표 현황을 조회합니다.")
    public ResponseEntity<BasicResponse> getItemVote(@RequestHeader("id") Long userId,@PathVariable(name = "roomId") Long roomId) {

        VoteDto.get get = voteService.getVote(userId, roomId);
        int count = userRoomRepository.countAllByRoom_Id(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 현황 조회 성공!")
                .count(count)
                .result(Collections.singletonList(get))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 해당 항목에 투표한 사람 조회 -> item id 필요
    @GetMapping("/item/{itemId}")
    @Operation(summary = "항목 투표자 조회", description = "해당 항목에 투표한 사람을 조회합니다.")
    public ResponseEntity<BasicResponse> getItemVoteUser(@PathVariable(name = "itemId") Long itemId) {

        List<String> userList = voteService.getUserList(itemId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("항목 투표자 조회 성공!")
                .count(userList.size())
                .result(Collections.singletonList(userList))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 사용자 투표 수정
    @PutMapping("")
    @Operation(summary = "투표 수정", description = "사용자의 투표를 수정합니다.")
    public ResponseEntity<BasicResponse> putVote(@RequestHeader("id") Long userId, @RequestBody VoteDto.put put) {
        voteService.updateVote(userId, put);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 수정 완료")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

}
