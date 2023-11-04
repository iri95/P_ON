package com.wanyviny.promise.domain.common;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
@Schema(name = "response", description = "반환값")
public class BasicResponse {

    @Builder.Default
    @Schema(name = "httpStatus", description = "Http 상태", example = "OK")
    private HttpStatus httpStatus = HttpStatus.OK;

    @Builder.Default
    @Schema(name = "code", description = "Http 상태 코드", example = "200")
    private Integer code = HttpStatus.OK.value();

    @Schema(name = "message", description = "결과 메세지", example = "성공")
    private String message;

    @Schema(name = "count", description = "결과 개수", example = "1")
    private Integer count;

    private List<Object> result;
}
