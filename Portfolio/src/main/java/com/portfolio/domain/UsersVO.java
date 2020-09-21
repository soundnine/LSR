package com.portfolio.domain;

import lombok.Data;

@Data
public class UsersVO {
	public static final String type = "users";
	
	private String userId;
	private String password;
	private String userName;
	private int gender;
	private String birthday;
	private String email;
	private AttachVO attachVO;
	private ChannelVO channelVO;
}
