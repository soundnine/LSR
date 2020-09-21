package com.portfolio.commons.socket;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.portfolio.domain.UsersVO;

public class WebSocketHandler extends TextWebSocketHandler{
	Map<String,WebSocketSession> wSessions = new ConcurrentHashMap<>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println("**********WebSocketHandler Connected**********");
		
		String id = "";
		Map<String,Object> hSession = session.getAttributes(); //can be populated initially through a HandshakeInterceptor. 인터셉터의 httpSession으로 채워진다.
		UsersVO users = (UsersVO) hSession.get("login");
		
		if(users == null) {
			id = session.getId();//웹소켓 세션 id
		} else {
			id = users.getUserId();//유저이름
		}
		
		wSessions.put(id, session); //사람들 담아놓기
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		System.out.println("session: "+ session +"message: "+ message);

		String id = "";
		Map<String,Object> hSession = session.getAttributes();
		UsersVO users = (UsersVO) hSession.get("login");
		
		if(users == null) {
			id = session.getId();//웹소켓 세션 id
		} else {
			id = users.getUserId();//유저이름
		}
		
		String messages = message.getPayload();//never null
		if(messages != "") {
			String[] splited = messages.split(",");
			if(splited.length == 2) {
				String follower = splited[0];
				String followee = splited[1];
				
				WebSocketSession followeeSession = wSessions.get(followee);
				if(followeeSession != null) {
					TextMessage txtMsg = new TextMessage(follower + "님이 팔로우 했습니다.");
					followeeSession.sendMessage(txtMsg);
				}
			}
			
		}
			
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.println("**********WebSocketHandler Closed**********");
	}

}
