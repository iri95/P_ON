package com.wanyviny.promise.domain.item.controller;

import com.wanyviny.promise.domain.common.BasicResponse;
import com.wanyviny.promise.domain.item.dto.ItemRequest;
import com.wanyviny.promise.domain.item.dto.ItemResponse;
import com.wanyviny.promise.domain.item.service.ItemService;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.Collections;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/item")
@Tag(name = "투표 항목", description = "투표 항목 관련 API")
public class ItemController {

    private final ItemService itemService;

    @PostMapping("/{roomId}")
    public ResponseEntity<BasicResponse> createItem(
            @RequestHeader("id") Long userId,
            @PathVariable Long roomId,
            @RequestBody ItemRequest.Create request) {

        ItemResponse.Create response = itemService.createItem(userId, roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 생성 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/{roomId}")
    public ResponseEntity<BasicResponse> modifyItem(
            @RequestHeader("id") Long userId,
            @PathVariable Long roomId,
            @RequestBody ItemRequest.Modify request) {

        ItemResponse.Modify response = itemService.modifyItem(userId, roomId, request);

        BasicResponse basicResponse = BasicResponse.builder()
                .message("투표 수정 성공")
                .count(1)
                .result(Collections.singletonList(response))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
