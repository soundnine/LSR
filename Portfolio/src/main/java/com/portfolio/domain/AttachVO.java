package com.portfolio.domain;

import lombok.Data;

@Data
public class AttachVO {
	private String uuid;
	private int freeBoardIdx;
	private int feedIdx;
	private String uploadPath;
	private String fileName;
	private String fileType;
	private Long fileSize;
	private String userId;
	private String channelName;
}
