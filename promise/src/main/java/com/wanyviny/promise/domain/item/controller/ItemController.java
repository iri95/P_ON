package com.wanyviny.promise.domain.item.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.item.dto.ItemRequest;
import com.wanyviny.promise.domain.item.dto.ItemResponse;
import com.wanyviny.promise.domain.item.entity.ItemType;
import com.wanyviny.promise.domain.item.service.ItemService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/item")
@Tag(name = "투표 항목", description = "투표 항목 관련 API")
public class ItemController {

    private final ItemService itemService;

    @PostMapping("/{roomId}")
    @Operation(summary = "투표 항목 생성", description = "투표 항목을 생성 합니다.")
    public ResponseEntity<BasicResponse> createItem(
            @RequestHeader("id") Long userId,
            @PathVariable Long roomId,
            @RequestBody ItemRequest.Create request) {

        ItemResponse.Create response = itemService.createItem(userId, roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 항목 생성 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/{roomId}")
    @Operation(summary = "투표 항목 조회", description = "투표 항목을 조회 합니다.")
    public ResponseEntity<BasicResponse> findItem(@PathVariable Long roomId) {

        ItemResponse.Find response = itemService.findItem(roomId);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 항목 조회 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/{roomId}")
    @Operation(summary = "투표 항목 수정", description = "투표 항목을 수정 합니다.")
    public ResponseEntity<BasicResponse> modifyItem(
            @RequestHeader("id") Long userId,
            @PathVariable Long roomId,
            @RequestBody ItemRequest.Modify request) {

        ItemResponse.Modify response = itemService.modifyItem(userId, roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 항목 수정 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @DeleteMapping("/{roomId}/{itemType}")
    @Operation(summary = "투표 타입 항목 삭제", description = "투표 항목을 수정 합니다.")
    public ResponseEntity<BasicResponse> deleteItemType(
            @PathVariable(name = "roomId") Long roomId,
            @PathVariable(name = "itemType")ItemType itemType) {

        itemService.deleteItemType(roomId, itemType);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 항목 삭제 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/{roomId}/{itemType}")
    @Operation(summary = "투표 타입 항목 삭제", description = "투표 항목을 수정 합니다.")
    public ResponseEntity<BasicResponse> putItemType(
            @PathVariable(name = "roomId") Long roomId,
            @PathVariable(name = "itemType")ItemType itemType) {

        itemService.putItemType(roomId, itemType);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 항목 확정")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
