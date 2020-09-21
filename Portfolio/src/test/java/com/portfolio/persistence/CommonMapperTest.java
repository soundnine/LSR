package com.portfolio.persistence;

import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class CommonMapperTest {
	@Autowired
	ICommonMapper mapper;
	
	@Test
	public void mainListPagingTest(){
		String userId = "admin";
		
		List<Map<String,Object>> list = mapper.getNewFeeds(userId,1);
		log.info(list);
		log.info("List0: "+list.get(0));
		
		log.info("CHANNELNAME: "+list.get(0).get("CHANNELNAME"));
		
		
	}
	
	
}
