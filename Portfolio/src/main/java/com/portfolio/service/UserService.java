package com.portfolio.service;

import com.portfolio.domain.LoginVO;
import com.portfolio.domain.UsersVO;

public interface UserService {
	
	public UsersVO getUserInfo(UsersVO vo);
	
	public UsersVO login(LoginVO vo);
	
	public void register(UsersVO vo);
	
	public void modifyUserInfo(UsersVO vo);
}
