package com.portfolio.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class FreeBoardVO {
	public static final String type = "freeBoard";
	
	private int rn; //ROWNUM
	private int idx;
	private String title;
	private String content;
	private String writer;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date updateDate;
	private int counts;
	private int locking;
	private String lockingPassword;
	private int likes;
	private int alert;
	private int parentIdx;
	private int attachCount;
	private int replyCount;
}
