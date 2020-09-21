package com.portfolio.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.portfolio.domain.FreeBoardVO;

import lombok.extern.log4j.Log4j;

@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml","file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
@Log4j
public class ControllerTest {
	//private FreeController freeController;
	@Autowired
	private CommonController controller;
	private MockMvc mockMvc;
	
	@Before
	public void buildMvc() {
		mockMvc = MockMvcBuilders.standaloneSetup(controller).build();
	}
	
//	@Test
//	public void removeServiceTest() throws Exception {
//		RequestBuilder builder = MockMvcRequestBuilders.post("/free/removeBoard").param("idx", "55");
//		mockMvc.perform(builder).andExpect(MockMvcResultMatchers.status().isOk()).andDo(MockMvcResultHandlers.print());
//	}
	
//	@Test
//	public void mainTest() throws Exception {
//		RequestBuilder builder = MockMvcRequestBuilders.get("/getNewFeeds/admin/1");
//		mockMvc.perform(builder).andExpect(MockMvcResultMatchers.status().isOk()).andDo(MockMvcResultHandlers.print());
//	}

}
