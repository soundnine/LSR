package com.portfolio.service;

import java.io.IOException;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.portfolio.domain.AttachVO;

public interface AttachService {
	
	
	public List<AttachVO> uploadImage(MultipartFile[] files, String nameType, String name) throws RuntimeException, IOException;

	public List<AttachVO> getAttachList(String boardType,int idx);
	
	public List<AttachVO> getImagePathForUsersAndCh(String nameType, String name);
	
	public int countAttach(String boardType,int idx);
	
	public String[] getAllUuid(String boardType,int idx);
	
	public List<AttachVO> getAllFeedAttachList(List<Integer> list);
	
	public void uploadAttach(MultipartFile[] files, String boardType, int idx) throws RuntimeException, IOException;
	
	public void removeAttachAll(String boardType,int idx);
	
	public void removeSelectedAttach(List<String> list);
	
	public void removeLocalFilesByUuids(List<String> list);
	
	public void removeLocalFilesByIdx(String boardType, int idx);
	
	
}
