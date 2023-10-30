package com.wanyviny.promise.domain.common;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class BasicResponse {

    @Builder.Default
    private HttpStatus httpStatus = HttpStatus.OK;

    @Builder.Default
    private Integer code = HttpStatus.OK.value();

    private String message;
    private Integer count;
    private List<Object> result;
}
