package com.portfolio.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.portfolio.domain.AttachVO;
import com.portfolio.domain.FreeBoardVO;

public interface IFreeMapper {

	public FreeBoardVO getFreeBoard(int idx);
	
	public List<FreeBoardVO> getFreeBoardList(@Param("page") int page, @Param("type") String type, @Param("keyword") String keyword);//페이징, 검색
	
	public void insert(FreeBoardVO vo);
	
	public void update(FreeBoardVO vo);
	
	public void delete(int idx);
	
	public int getTotal(@Param("type") String type, @Param("keyword") String keyword); //검색 옵션 게시물 수
	
	public String getTitle(int idx);
	
	public void updateAndGetCount(FreeBoardVO vo); //SelectKey로 int가 리턴되긴하지만 우선 update를 하므로 리턴타입 void. 파라미터에 int로 바로 idx를 주면 setter로 counts를 세팅할 수 있는 객체가 없어서 vo에 idx set해서 vo로 counts 받아오기.
	
	public int getLikesCounts(int boardIdx);
}
