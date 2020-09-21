package com.portfolio.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.portfolio.domain.AttachVO;

public interface IAttachMapper {
	
		public void insertAttach(AttachVO vo);
		
		public List<AttachVO> getAttachList(@Param("type") String boardType, @Param("idx") int idx);
		
		public void deleteAttachAll(@Param("type") String boardType, @Param("idx") int idx);
		
		public void deleteSelectedAttach(List<String> list);
		
		public void deleteUserAndChImage(@Param("type") String nameType, @Param("name") String name);
		
		public List<AttachVO> getLocalPathsByUuids(@Param("list") List<String> list);
		
		public List<AttachVO> getLocalPathsByIdx(@Param("type") String boardType, @Param("idx") int idx);
		
		public List<AttachVO> getLocalPathsByName(@Param("type") String nameType, @Param("name") String name);
		
		public List<AttachVO> getAllFeedAttachList(List<Integer> list);
		
		public int countAttach(@Param("type") String boardType, @Param("idx") int idx);
		
		public String[] getAllUuid(@Param("type") String boardType, @Param("idx") int idx); //uuid 비교 후 게시물 첨부파일 수정
		
		
		
}
