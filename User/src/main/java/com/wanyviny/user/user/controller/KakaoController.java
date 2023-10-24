package com.wanyviny.user.user.controller;

import com.wanyviny.user.user.dto.KakaoDto;
import com.wanyviny.user.user.service.KakaoService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("kakao")
public class KakaoController {

    private final KakaoService kakaoService;

    @GetMapping("/callback")
    public ResponseEntity<KakaoDto> callback(HttpServletRequest request) throws Exception {
        KakaoDto kakaoInfo = kakaoService.getKakaoInfo(request.getParameter("code"));

        return new ResponseEntity<>(kakaoInfo, HttpStatus.OK);
    }
}
