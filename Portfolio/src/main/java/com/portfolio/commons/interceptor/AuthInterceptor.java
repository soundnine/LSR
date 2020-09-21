package com.portfolio.commons.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import lombok.extern.log4j.Log4j;

@Log4j
public class AuthInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		
		log.info("Auth Check@@@");
		log.info(session.getAttribute("login"));
		
		//로그인 안한 사람 막기
		if(session.getAttribute("login") == null) {
			response.sendRedirect("/login");
			return false;
		}
		
		return true;
	}

}
