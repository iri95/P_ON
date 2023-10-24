package com.wanyviny.user.user.controller;

import com.wanyviny.user.user.service.KakaoService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@RequiredArgsConstructor
@Controller
public class HomeController {

    private final KakaoService kakaoService;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String login(Model model){
        System.out.println("접속");
        model.addAttribute("kakaoUrl", kakaoService.getKakaoLogin());
        System.out.println("접속?");
        return "index";
    }
}
