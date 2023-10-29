package com.wanyviny.user.user.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@RequiredArgsConstructor
@Controller
public class HomeController {

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String enter(){
        System.out.println("접속");
        return "index.html";
    }
}
