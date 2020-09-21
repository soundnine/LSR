package com.portfolio.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.portfolio.domain.FreeBoardVO;

public interface ICommonMapper {
	
	public List<FreeBoardVO> getPopularBoards();
	
	public List<Map<String,Object>> getNewFeeds(@Param("userId")String userId, @Param("page") int page);
	
	public int getNewFeedsCount(String userId);
	
	public int getLikeUserCount(@Param("accessId") String accessId, @Param("type") String type, @Param("idx") int idx);
	
	public int[] getAllIdxLikeFeeds(String accessId);
	
	public void updateLikeCount(@Param("plusMinus")String plusMinus, @Param("accessId") String accessId
							   ,@Param("type") String type, @Param("idx") int idx);
}
