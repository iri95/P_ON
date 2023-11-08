package com.wanyviny.calendar.domain.calendar.controller;

import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;
import com.wanyviny.calendar.domain.calendar.service.CalendarService;
import com.wanyviny.calendar.domain.common.BasicResponse;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/calendar")
public class CalendarController {

    private final CalendarService calendarService;

    // 일정 생성
    @PostMapping("/schedule")
    @Transactional
    public ResponseEntity<BasicResponse> postSchedule(HttpServletRequest request, @RequestBody CalendarDto.setSchedule schedule) {
        Long id = Long.parseLong(request.getHeader("id"));

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
        Long id = Long.parseLong(request.getHeader("id"));

        List<CalendarDto.getSchedule> redisCalendarDtoList = calendarService.getMySchedule(id);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("일정 조회 성공!")
                .count(redisCalendarDtoList.size())
                .result(Collections.singletonList(redisCalendarDtoList))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 일정 상세 조회
    @GetMapping("/schedule/detail/{calendarId}")
    public ResponseEntity<BasicResponse> getDetailSchedule(HttpServletRequest request, @PathVariable(name = "calendarId") Long calendarId) {
        Long id = Long.parseLong(request.getHeader("id"));

        CalendarDto.getSchedule schedule = calendarService.getDetailSchedule(id, calendarId);

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
        Long id = Long.parseLong(request.getHeader("id"));

        List<CalendarDto.promiseScheduleDto> getScheduleList = calendarService.getUserSchedule(id, userId);

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
    public ResponseEntity<BasicResponse> updateSchedule(HttpServletRequest request, @PathVariable(name = "calendarId") Long calendarId, @RequestBody CalendarDto.setSchedule schedule) {
        Long id = Long.parseLong(request.getHeader("id"));

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
    public ResponseEntity<BasicResponse> deleteSchedule(HttpServletRequest request, @PathVariable(name = "calendarId") Long calendarId) {
        Long id = Long.parseLong(request.getHeader("id"));

        calendarService.deleteSchedule(id, calendarId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("일정 삭제 성공!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @DeleteMapping("/schedule/deleteList/{calendarId}")
    public ResponseEntity<BasicResponse> deleteSchedule(HttpServletRequest request, @PathVariable(name = "calendarId") Long calendarId, @RequestParam List<Long> deleteList) {
        Long id = Long.parseLong(request.getHeader("id"));

        calendarService.deleteScheduleList(id, deleteList);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("일정 삭제 성공!")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 여러명의 일정 가져오기 -> 그사람의 PRIVACY에 상관 없이 가져옴, 상세적인 일정은 가져가지 않음
    @GetMapping("/schedule/promise")
    public ResponseEntity<BasicResponse> getPromiseSchedule(@RequestParam List<Long> userIdList) {

        Map<String, List<CalendarDto.promiseScheduleDto>> calendarDtoList = calendarService.getPromiseSchedule(userIdList);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("약속 일정 조회 성공!")
                .count(calendarDtoList.size())
                .result(Collections.singletonList((calendarDtoList)))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

}
