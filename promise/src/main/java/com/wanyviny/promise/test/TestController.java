package com.wanyviny.promise.test;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping("/api/promise/test")
    public String test() {
        return "연결 성공!!!";
    }
}
