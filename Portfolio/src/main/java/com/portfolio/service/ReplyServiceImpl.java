package com.portfolio.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.portfolio.domain.ReplyVO;
import com.portfolio.persistence.IReplyMapper;

@Service
public class ReplyServiceImpl implements ReplyService {
	@Autowired
	IReplyMapper mapper;
	
	@Transactional
	@Override
	public Map<String,Object> getReplyList(String boardType, int boardIdx, int page) {
		
			List<ReplyVO> replyList = mapper.getReplyList(boardType, boardIdx, page);
			Integer totalCount = mapper.getTotalCount(boardIdx, boardType);
			
			Map<String,Object> replyCountAndList = new HashMap<>();
			replyCountAndList.put("replyList", replyList);
			replyCountAndList.put("totalCount", totalCount);
			
			
		return replyCountAndList;
	}

	@Override
	public ReplyVO getReply(int replyIdx) {
		return mapper.getReply(replyIdx);
	}

	@Override
	public void registerReply(ReplyVO vo) {
		mapper.insertReply(vo);
	}

	@Override
	public void modifyReply(String replyContent, int replyIdx) {
		mapper.updateReply(replyContent, replyIdx);
	}

	@Override
	public void removeReply(int replyIdx) {
		mapper.deleteReply(replyIdx);
	}

}
