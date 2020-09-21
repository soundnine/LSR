package com.portfolio.domain;

import java.util.Date;

import lombok.Data;

@Data
public class FeedVO {
	public static final String type = "feed";
	
	private int idx;
	private String title;
	private String writer;
	private String content;
	private Date updateDate;
	private int likes;
	private String likeUser;
}
