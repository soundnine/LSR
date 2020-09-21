package com.portfolio.commons.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import lombok.extern.log4j.Log4j;

@Log4j
public class LoginInterceptor extends HandlerInterceptorAdapter{

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		//기존 로그인 정보 제거   세션 새로
		if(session.getAttribute("login") != null) {
			session.removeAttribute("login");
		}
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		HttpSession session = request.getSession();
		log.warn("login modelAndView: "+modelAndView);
		ModelMap model = modelAndView.getModelMap();
		Object usersVO = model.get("user"); //loginPost에서 넣은것 꺼내옴
		
		if(usersVO != null) {
			session.setAttribute("login", usersVO);
			response.sendRedirect("/main");
		}
	}

}
