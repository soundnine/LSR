package com.portfolio.domain;

import lombok.Data;

@Data
public class ChannelVO {
	public static final String type = "channel";
	
	private String channelName;
	private String channelOwner;
	private int followNum;
	private AttachVO attachVO;
}
