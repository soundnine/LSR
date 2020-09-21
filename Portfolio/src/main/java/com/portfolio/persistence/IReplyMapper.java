package com.portfolio.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.portfolio.domain.ReplyVO;

public interface IReplyMapper {
	
	public List<ReplyVO> getReplyList(@Param("type") String boardType, @Param("boardIdx") int boardIdx, @Param("page") int page);
	
	public ReplyVO getReply(int replyIdx);
	
	public Integer getTotalCount(@Param("boardIdx") int boardIdx, @Param("type") String type);
	
	public void insertReply(ReplyVO vo);
	
	public void updateReply(@Param("replyContent")String replyContent, @Param("replyIdx") int replyIdx);
	
	public void deleteReply(int replyIdx);
	
}
