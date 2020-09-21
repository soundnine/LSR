package com.portfolio.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.portfolio.domain.ChannelVO;
import com.portfolio.domain.FeedVO;

public interface IChannelMapper {
	
	public List<ChannelVO> getChannelAndList(String channelName);
	
	public List<FeedVO> getAllFeeds(String channelOwner);
	
	public int getChannelCountById(String userId);
	
	public int getWhetherFollow(@Param("channelName") String channelName, @Param("userId") String userId);
	
	public String[] getFollowList(String userId); 
	
//	public ChannelVO getChannel(String channelOwner);
	
	public void insertChannel(@Param("channelName") String channelName, @Param("channelOwner") String channelOwner);
	
	public void insertFeed(FeedVO vo);
	
	public void insertFollow(@Param("channelName") String channelName, @Param("userId") String userId);
	
	public void deleteFollow(@Param("channelName") String channelName, @Param("userId") String userId);
	
	public void updateFollowCount(@Param("channelName") String channelName, @Param("followUnfollow") String followUnfollow);
	
}
