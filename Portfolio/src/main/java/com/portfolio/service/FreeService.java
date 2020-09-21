package com.portfolio.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.portfolio.domain.FreeBoardVO;

public interface FreeService {
	//게시글
	public List<FreeBoardVO> getFreeBoardList(int page, String type, String keyword); 
	
	public Map<String, Object> getFreeBoard(int idx);
	
	public void registerFreeBoard(MultipartFile[] files, FreeBoardVO vo) throws Exception;
	
	public void modifyFreeBoard(String[] uuid, MultipartFile[] files, FreeBoardVO vo) throws  Exception;
	
	public void removeBoard(int idx);
	
	public int getTotalCount(String type, String keyword);
	
	public String getTitle(int idx);
	
	public int updateAndGetCount(int idx);
	
	public int getLikesCounts(int boardIdx);
}
