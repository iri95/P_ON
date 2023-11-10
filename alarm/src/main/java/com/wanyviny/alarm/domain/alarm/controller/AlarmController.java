package com.wanyviny.alarm.domain.alarm.controller;

import com.wanyviny.alarm.domain.alarm.ALARM_TYPE;
import com.wanyviny.alarm.domain.alarm.dto.AlarmDto;
import com.wanyviny.alarm.domain.alarm.service.AlarmService;
import com.wanyviny.alarm.domain.common.BasicResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/alarm")
@RequiredArgsConstructor
@Tag(name = "알람", description = "알람 관련 API")
public class AlarmController {

    private final AlarmService alarmService;

    // 알림 조회 -> 유저의 Id로 역순
    @GetMapping
    @Operation(summary = "알람 조회", description = "개인 알람을 모두 조회합니다.(헤더에 id 필요)")
    public ResponseEntity<BasicResponse> getAlarm(HttpServletRequest request) {
        Long userId = Long.parseLong(request.getHeader("id"));

        List<AlarmDto.getAlarmDto> alarmDto = alarmService.getAlarm(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("알림 조회 성공")
                .count(alarmDto.size())
                .result(Collections.singletonList(alarmDto))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/type/{alarmType}")
    @Operation(summary = "타입별 알람 조회", description = "타입별 개인 알람을 모두 조회합니다.(헤더에 id 필요), Type : FRIEND, INVITE, CREATE_POLL, END_POLL, END_PROMISE")
    public ResponseEntity<BasicResponse> getAlarmByType(HttpServletRequest request, @PathVariable(name = "alarmType") ALARM_TYPE alarmType) {
        Long userId = Long.parseLong(request.getHeader("id"));

        List<AlarmDto.getAlarmDto> alarmDto = alarmService.getAlarmByType(userId, alarmType);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("알림 조회 성공")
                .count(alarmDto.size())
                .result(Collections.singletonList(alarmDto))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/count")
    @Operation(summary = "알람 개수 조회", description = "개인의 알람 개수를 모두 조회합니다.(헤더에 id 필요)")
    public ResponseEntity<BasicResponse> getAlarmCount(HttpServletRequest request) {
        Long userId = Long.parseLong(request.getHeader("id"));

        int alarmDto = alarmService.getAlarmCount(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("알람 개수 조회 성공")
                .count(alarmDto)
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @GetMapping("/count/non-read")
    @Operation(summary = "안 읽은 알람 개수 조회", description = "개인의 안 읽은 알람 개수를 모두 조회합니다.(헤더에 id 필요)")
    public ResponseEntity<BasicResponse> getAlarmCountNonRead(HttpServletRequest request) {
        Long userId = Long.parseLong(request.getHeader("id"));

        Long alarmDto = alarmService.getAlarmCountNonRead(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("읽지 않은 알람 개수 조회 성공")
                .count(Math.toIntExact(alarmDto))
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/read-only")
    @Operation(summary = "알람 단일 읽음 처리", description = "하나의 알람을 읽음 처리합니다. {'alarmId' : 'String'}")
    public ResponseEntity<BasicResponse> putAlarmState(@RequestBody Map<String, String> alarmId) {

        alarmService.putAlarmState(Long.parseLong(alarmId.get("alarmId")));

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("해당 알람 읽음 처리 완료")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    @PutMapping("/read-all")
    @Operation(summary = " 모든 알람 읽음 처리", description = "유저의 모든 알람을 읽음 처리합니다.(헤더에 id 필요)")
    public ResponseEntity<BasicResponse> putAlarmState(HttpServletRequest request) {
        Long userId = Long.parseLong(request.getHeader("id"));

        alarmService.putAlarmStateAll(userId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("모든 알람 읽음 처리 완료")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 알림 삭제 -> 알림 확인 시 알림 삭제
    @DeleteMapping("/delete/{alarmId}")
    @Operation(summary = " 해당 알람 삭제 처리", description = "유저의 해당 알람을 삭제 처리합니다. {'alarmId' : 'String'}")
    public ResponseEntity<BasicResponse> deleteAlarm( @PathVariable(name = "alarmId") Long alarmId) {

        alarmService.deleteAlarm(alarmId);

        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("알림 삭제 완료")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }

    // 알림 모두 삭제 -> 사용자의 Id로 알림을 모두 삭제
    @DeleteMapping("/delete/all")
    @Operation(summary = " 모든 알람 삭제 처리", description = "유저의 모든 알람을 삭제 처리합니다.(헤더에 id 필요)")
    public ResponseEntity<BasicResponse> deleteAlarmAll(HttpServletRequest request) {
        Long userId = Long.parseLong(request.getHeader("id"));

        alarmService.deleteAlarmAll(userId);


        BasicResponse basicResponse = BasicResponse.builder()
                .code(HttpStatus.OK.value())
                .httpStatus(HttpStatus.OK)
                .message("카카오에서 받은 유저 정보 조회 성공")
                .build();

        return new ResponseEntity<>(basicResponse, basicResponse.getHttpStatus());
    }
}
