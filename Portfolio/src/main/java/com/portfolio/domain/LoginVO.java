package com.portfolio.domain;

import lombok.Data;

@Data
public class LoginVO {
	private String userId;
	private String password;
	private boolean useCookie;
}
