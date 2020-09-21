package com.portfolio.commons.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.portfolio.domain.FreeBoardVO;
import com.portfolio.domain.UsersVO;

import lombok.extern.log4j.Log4j;

@Log4j
public class FreeInterceptor extends HandlerInterceptorAdapter{
	 
	


	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView model) throws Exception {
		HttpSession session = request.getSession();
		UsersVO sessionVO = (UsersVO)session.getAttribute("login");
		log.warn("modelAndView: "+model);
		log.warn(request.getParameter("string"));
		
		if(request.getParameter("string") != null && request.getParameter("string").equals("success")) {
			return;
		}
		
;		ModelMap map = model.getModelMap();
		FreeBoardVO vo = (FreeBoardVO) map.get("vo");
		String accessId = sessionVO.getUserId();
		String lockingWriter = vo.getWriter();		
		
		String idx = Integer.toString(vo.getIdx());
		String page = Integer.toString((int) map.get("page"));
		String type = (String) map.get("type");
		String keyword = (String) map.get("keyword");
		
		
		//글 잠금 여부. get요청시 request.getsession 세션아이디 받아서 vo.getwriter와 비교 락킹이 1이고 아이디가 서로 같지않다면 경우만 check, 나머지 경우는 free access
		if(vo.getLocking()==1&&!lockingWriter.equals(accessId)) {
			response.sendRedirect("/free/checkBoardPw?idx="+idx+"&page="+page+"&type="+type+"&keyword="+keyword+"");
	}

}
}
