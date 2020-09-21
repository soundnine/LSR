package com.portfolio.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.portfolio.domain.AttachVO;
import com.portfolio.domain.FreeBoardVO;

public interface CommonService {
	
	public List<FreeBoardVO> getPopularBoards();
	
	public List<AttachVO> uploadImage(MultipartFile[] files, String nameType, String name) throws RuntimeException, IOException;
	
	public List<Map<String,Object>> getNewFeeds(String userId, int page);
	
	public int getNewFeedsCount(String userId);
	
	public int checkLikeUser(String accessId, String type, int idx);
	
	public int[] checkLikeUserAllFeeds(String accessId);
	
	public void updateLikeCount(String plusMinus, String accessId, String type, int idx);
}
