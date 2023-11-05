package com.wanyviny.calendar.domain.calendar.controller;

import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;
import com.wanyviny.calendar.domain.calendar.service.CalendarService;
import com.wanyviny.calendar.domain.common.BasicResponse;
import com.wanyviny.calendar.global.service.JwtService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/calendar")
public class CalendarContoller {

    private final CalendarService calendarService;
    private final JwtService jwtService;

    // 일정 생성
    @PostMapping("/schedule")
    @Transactional
    public ResponseEntity<BasicResponse> postSchedule(HttpServletRequest request, @RequestBody CalendarDto.setSchedule schedule) {
//        String accessToken = request.getHeader("Authorization").replace("Bearer ", "");
//
//        Long id = jwtService.extractId(accessToken).orElseThrow(
//                () -> new IllegalArgumentException("Access Token에 해당하는 id가 없습니다.")
//        );
        Long id = 1L;
        calendarService.postSchdule(id, schedule);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("일정 저장 완료!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 일정 조회
    @GetMapping("/schedule")
    public ResponseEntity<BasicResponse> getSchedule(HttpServletRequest request) {
//        String accessToken = request.getHeader("Authorization").replace("Bearer ", "");
//
//        Long id = jwtService.extractId(accessToken).orElseThrow(
//                () -> new IllegalArgumentException("Access Token에 해당하는 id가 없습니다.")
//        );
        Long id = 1L;

        List<CalendarDto.getSchedule> calendarDto = calendarService.getMySchedule(id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("일정 조회 성공!")
                .count(calendarDto.size())
                .result(Arrays.asList(calendarDto.toArray()))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 일정 상세 조회
    @GetMapping("/schedule/detail/{calendarId}")
    public ResponseEntity<BasicResponse> getDetailSchedule(@PathVariable(name = "calendarId") Long calendarId) {

        CalendarDto.getSchedule schedule = calendarService.getDetailSchedule(calendarId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("상세 일정 조회 성공!")
                .count(1)
                .result(Collections.singletonList(schedule))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 타인 일정 조회 -> 조회하려는 사람의 PRIVACY를 알아야 함, 어떤 일정인지는 상세하게 X
    @GetMapping("/schedule/user/{userId}")
    public ResponseEntity<BasicResponse> getUserSchedule(HttpServletRequest request, @PathVariable(name = "userId") Long userId) {
//        String accessToken = request.getHeader("Authorization").replace("Bearer ", "");
//
//        Long id = jwtService.extractId(accessToken).orElseThrow(
//                () -> new IllegalArgumentException("Access Token에 해당하는 id가 없습니다.")
//        );
        Long id = 4L;

        List<CalendarDto.getSchedule> getScheduleList = calendarService.getUserSchedule(id, userId);

        if (getScheduleList == null) {
            BasicResponse basicResponse = BasicResponse.builder()
                    .code(HttpStatus.NOT_FOUND.value())
                    .httpStatus(HttpStatus.NOT_FOUND)
                    .message("일정을 확인할 수 없습니다.")
                    .build();

            return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
        } else {

            BasicResponse basicResponse = BasicResponse.builder()
                    .code(HttpStatus.OK.value())
                    .httpStatus(HttpStatus.OK)
                    .message("타인 일정 조회 성공!")
                    .count(getScheduleList.size())
                    .result(Arrays.asList(getScheduleList.toArray()))
                    .build();

            return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
        }
    }

    // 일정 수정
    @PutMapping("/schedule/{calendarId}")
    @Transactional
    public ResponseEntity<BasicResponse> updateSchedule(@PathVariable(name = "calendarId") Long calendarId, @RequestBody CalendarDto.setSchedule schedule) {
//        String accessToken = request.getHeader("Authorization").replace("Bearer ", "");
//
//        Long id = jwtService.extractId(accessToken).orElseThrow(
//                () -> new IllegalArgumentException("Access Token에 해당하는 id가 없습니다.")
//        );
        Long id = 1L;

        calendarService.updateSchedule(id, calendarId, schedule);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("일정 수정 성공!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 일정 삭제
    @DeleteMapping("/schedule/{calendarId}")
    public ResponseEntity<BasicResponse> deleteSchedule(@PathVariable(name = "calendarId") Long calendarId) {
//        String accessToken = request.getHeader("Authorization").replace("Bearer ", "");
//
//        Long id = jwtService.extractId(accessToken).orElseThrow(
//                () -> new IllegalArgumentException("Access Token에 해당하는 id가 없습니다.")
//        );
        Long id = 1L;
        calendarService.deleteSchedule(id, calendarId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("일정 삭제 성공!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 여러명의 일정 가져오기 -> 그사람의 PRIVACY를 상관 없이 가져옴, 상세적인 일정은 가져가지 않음
    @GetMapping("/schedule/promise")
    public ResponseEntity<BasicResponse> getPromiseSchedule(@RequestParam List<Long> userIdList) {

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("약속 일정 조회 성공!")
                .count(1)
//                .result()
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

}
