package com.portfolio.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.portfolio.domain.LoginVO;
import com.portfolio.domain.UsersVO;
import com.portfolio.service.UserService;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class LoginController {
	@Autowired
	UserService service;
	
	@GetMapping("/")
	public String home() {
		return "/login";
	}
	
	@GetMapping("/login")
	public void loginGET(@ModelAttribute("loginVO") LoginVO vo) {
		
	}
	
	@GetMapping("/logout")
	public void logout(HttpSession session) {
		
		Object object = session.getAttribute("login");
		if(object != null) {
			session.removeAttribute("login");
			session.invalidate();
		}
	}
	
	@GetMapping("/main")
	public void main() {
	}
	
	@PostMapping("/loginPost") //세션 -> 인터셉터 처리
	public void loginPOST(LoginVO loginVO, Model model) throws UnsupportedEncodingException {
		UsersVO usersVO = service.login(loginVO);
		log.info(loginVO);
		log.info(usersVO);
		if(usersVO == null || !BCrypt.checkpw(loginVO.getPassword(), usersVO.getPassword())) {
			return;
		}
		//인코딩을 안해주니까 계쏙 세퍼레이터가 화면단에서 이상하게 나옴.
		if(usersVO.getAttachVO() != null) {
		String uploadPath = usersVO.getAttachVO().getUploadPath();
		uploadPath = URLEncoder.encode(uploadPath, "UTF-8");
		usersVO.getAttachVO().setUploadPath(uploadPath);
		}
		
		model.addAttribute("user", usersVO);
		//비밀번호 동일 인터셉터로 보냄.
	}
	
}
