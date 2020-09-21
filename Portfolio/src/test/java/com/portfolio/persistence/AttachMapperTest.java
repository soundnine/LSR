package com.portfolio.persistence;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.portfolio.domain.AttachVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class AttachMapperTest {
	@Autowired
	IAttachMapper mapper;
	
//	@Test
//	public void insertTest() {
//		AttachVO vo = new AttachVO();
//		vo.setUuid("test");
//		vo.setFreeBoardIdx(3);
//		vo.setFileName("test123");
//		vo.setFileSize(1);
//		vo.setFileType("img");
//		vo.setUploadPath("testPath");
//		mapper.insertAttach(vo);
//	}
	
	@Test
	public void deleteTest() {
		mapper.deleteAttachAll("freeBoard", 3);
	}
}
