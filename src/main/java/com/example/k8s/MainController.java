package com.example.k8s;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {
    @RequestMapping(value = "/home")
    public String homePage(){
        return "index";
    }

    @RequestMapping(value = "/dev")
    public String devPage(){
        return "dev";
    }

}
