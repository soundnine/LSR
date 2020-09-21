package com.portfolio.domain;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class ReplyVO {
	private int idx;
	private int freeBoardIdx;
	private int feedIdx;
	private String reply;
	private String replyWriter;
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd")
	private Date updateDate;
	private int alert;
	private AttachVO attachVO;
}
