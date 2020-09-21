package com.portfolio.service;

import java.util.Map;

import com.portfolio.domain.ReplyVO;

public interface ReplyService {
	
	public Map<String,Object> getReplyList(String boardType, int boardIdx, int page);
	
	public ReplyVO getReply(int replyIdx);
	
	public void registerReply(ReplyVO vo);
	
	public void modifyReply(String replyContent, int replyIdx);
	
	public void removeReply(int replyIdx);
}
