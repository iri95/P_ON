package com.wanyviny.alarm.domain.common;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;

import java.util.List;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class BasicResponse {

    @Builder.Default
    private Integer code = HttpStatus.OK.value(); // http 상태코드명(OK, NOT FOUND)

    @Builder.Default
    private HttpStatus httpStatus = HttpStatus.OK; // http 상태코드번호(200, 404)

    private String message; // response 정보 (사용자 조회 성공)
    private Integer count; // 반환 개수
    private List<Object> result; // 실제 response 데이터
}
