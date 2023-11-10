package com.wanyviny.promise.domain.vote.controller;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/promise/vote")
@Tag(name = "투표", description = "투표 관련 API")
public class VoteController {

}
