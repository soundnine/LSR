package com.portfolio.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.portfolio.domain.LoginVO;
import com.portfolio.domain.UsersVO;
import com.portfolio.persistence.IUserMapper;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
	IUserMapper mapper;
	

	@Override
	public UsersVO login(LoginVO vo) {
		return mapper.login(vo);
	}
	
	@Override
	public UsersVO getUserInfo(UsersVO vo) {
		return mapper.getUserInfo(vo);
	}
	
	@Override
	public void register(UsersVO vo) {
		mapper.register(vo);	
	}

	@Override
	public void modifyUserInfo(UsersVO vo) {
		mapper.updateUserInfo(vo);
	}


}
