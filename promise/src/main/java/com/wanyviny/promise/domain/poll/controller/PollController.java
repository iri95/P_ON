//package com.wanyviny.promise.domain.poll.controller;
//
//import com.wanyviny.promise.domain.poll.entity.Poll;
//import com.wanyviny.promise.domain.poll.repository.PollRepository;
//import io.swagger.v3.oas.annotations.tags.Tag;
//import lombok.RequiredArgsConstructor;
//import org.springframework.web.bind.annotation.PathVariable;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestHeader;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//@RestController
//@RequiredArgsConstructor
//@RequestMapping("/api/poll")
//@Tag(name = "투표", description = "투표 관련 API")
//public class PollController {
//
//    private final PollRepository pollRepository;
//
//    @PostMapping("/{roomId}")
//    public void test(
//            @RequestHeader("id") Long userId,
//            @PathVariable Long roomId
//    ) {
//
//        Poll poll = Poll.builder()
//                .id(roomId)
//                .build();
//
//        pollRepository.save(poll);
//    }
//}
