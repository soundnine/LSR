package com.portfolio.controller;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.portfolio.domain.UsersVO;
import com.portfolio.service.UserService;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class UserController {
	@Autowired
	UserService service;
	
	@GetMapping("/preUserInfo")
	public void preUserInfo(){
		
	}
	
	@GetMapping("/register")
	public void registerGET() {
		
	}
	
	@PostMapping("/register")
	public String registerPOST(UsersVO vo) {
		String hashPw = BCrypt.hashpw(vo.getPassword(), BCrypt.gensalt());
		vo.setPassword(hashPw);
		log.info("@@@@register: "+vo);
		service.register(vo);
		
		
		return "redirect:/login";
	}
	
	@PostMapping("/userInfo")
	public String userInfoPOST(UsersVO vo, Model model) {
	    UsersVO userInfo = service.getUserInfo(vo);
	    String inputPW = vo.getPassword();
	    String existingPW = userInfo.getPassword();
	    log.info("@@@@@@@@@@@userInfo vo: "+vo);
	    if(vo == null || !BCrypt.checkpw(inputPW, existingPW)) {
			return "redirect:/preUserInfo";
		} else {
			model.addAttribute("userInfo",userInfo);
			return "/userInfo";
		}
	}
	
	@PostMapping("/userInfoAfter")
	public String userInfoAfterPOST(UsersVO vo) {
		if(vo.getPassword() != null) {
			String hashPw = BCrypt.hashpw(vo.getPassword(), BCrypt.gensalt());
			vo.setPassword(hashPw);
		}
		service.modifyUserInfo(vo);
		
		
		return "redirect:/main";
	}
}
