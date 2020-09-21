package com.portfolio.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.portfolio.domain.AttachVO;
import com.portfolio.domain.ChannelVO;
import com.portfolio.domain.FeedVO;

public interface ChannelService {
	
	public Map<String,Object> getChannelAndList(String channelName, String userId);
	
	public List<AttachVO> getChannelImagePath(String nameType, String name);
	
	public Map<String, Object> getAllFeeds(String channelOwner);

	public int getChannelCountById(String userId);
	
	public int getWhetherFollow(String channelName, String userId);
	
	public String[] getFollowList(String userId);
	
	public void registerChannel(String channelName, String channelOwner);
	
	public void registerFeed(MultipartFile[] files, FeedVO vo) throws RuntimeException, IOException;
	
	public void modifyFollow(String channelName, String userId, String followUnfollow) throws RuntimeException;
	
}
