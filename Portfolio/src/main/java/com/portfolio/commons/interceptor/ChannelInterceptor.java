package com.portfolio.commons.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.portfolio.domain.UsersVO;

public class ChannelInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		UsersVO users= (UsersVO) session.getAttribute("login");
		if(users.getChannelVO() == null) {
			response.sendRedirect("/channel/channelList");
			return false;
		}
		
		return true;
	}

}
