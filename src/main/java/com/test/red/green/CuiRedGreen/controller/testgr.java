package com.test.red.green.CuiRedGreen.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api")
public class testgr {
	
	@GetMapping("test")
	public String abc() {
		return "我是来测试的，你敢信这是第7次成功了（17：51）~~~~cloud deploy弄的~";
	}

}
