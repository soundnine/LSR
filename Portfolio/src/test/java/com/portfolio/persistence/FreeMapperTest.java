package com.portfolio.persistence;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.portfolio.domain.FreeBoardVO;
import com.portfolio.domain.UsersVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class FreeMapperTest {
	@Autowired
	IFreeMapper mapper;
	
	
	@Test
	public void updateCountTest() {
		FreeBoardVO vo = new FreeBoardVO();
		vo.setIdx(33);
		mapper.updateAndGetCount(vo);
		log.info(vo.getCounts());
		
		
	}
	
	
//	@Test
//	public void mapperTest() {
//		  FreeBoardVO vo = new FreeBoardVO(); vo.setTitle("테스트1"); vo.setWriter("테스트아이디");
//		  vo.setContent("테스트내용"); mapper.insert(vo);
//	}
	
//	@Test
//	public void pagingListTest() {
//		mapper.getFreeBoardList(1, "T", "테");
//		mapper.getFreeBoardList(2, "T", "테");
//		mapper.getFreeBoardList(3, "T", "테");
//	}
	
//	@Test
//	public void getBoardTest() {
//		mapper.getFreeBoard(3);
//	}
	
//	@Test
//	public void updateTest() {
//		FreeBoardVO vo = new FreeBoardVO();
//		vo.setIdx(2);
//		vo.setTitle("test code input title");
//		vo.setContent("test code input content");
//		mapper.update(vo);
//	}
	
//	@Test
//	public void totalTest() {
//		mapper.getTotal("t", "");
//	}
	
//	@Test
//	public void homeMapperTest() {
//		UsersVO users = new UsersVO();
//		users.setUserId("테스트아이디");
//		users.setPassWord("testpw12");
//		users.setUserName("테스트");
//		users.setGender(0);
//		users.setBirthday("19990909");
//		users.setEmail("test@naver.com");
//		hmapper.accountRegister(users);
//	}
	
}
