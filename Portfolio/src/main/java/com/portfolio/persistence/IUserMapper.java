package com.portfolio.persistence;

import com.portfolio.domain.LoginVO;
import com.portfolio.domain.UsersVO;

public interface IUserMapper {
	
	public void register(UsersVO vo);
	
	public UsersVO login(LoginVO vo);
	
	public void updateUserInfo(UsersVO vo);
	
	public UsersVO getUserInfo(UsersVO vo);
}
