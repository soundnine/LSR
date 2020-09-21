package com.portfolio.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.portfolio.domain.AttachVO;
import com.portfolio.domain.ChannelVO;
import com.portfolio.domain.FeedVO;
import com.portfolio.domain.UsersVO;
import com.portfolio.service.ChannelService;

import lombok.extern.log4j.Log4j;

@Log4j
@RequestMapping("/channel")
@Controller
public class ChannelController {
	@Autowired
	ChannelService service;
	
	
	@GetMapping("/channelList")//model 대신 ajax사용 -> ajax만으로 이것저것 불러와 로드하니  무한루프 팅김 등등 -> 해결
	public void getChannelList(Model model) {
	}
	
	@GetMapping("/getChannel")//channelList 서비스 재사용 -> 채널 이미지 정보O
	public void getChannel(String channelName, Model model) {
		Map<String,Object> channelAllInfo = service.getChannelAndList(channelName,"");
		List<ChannelVO> chContentAndImage = (List<ChannelVO>) channelAllInfo.get("chContentAndImage");
		
		//단일 선택
		String channelOwner = chContentAndImage.get(0).getChannelOwner();
		Map<String,Object> feedsMap = service.getAllFeeds(channelOwner);
		
		if(channelAllInfo.get("chOwnerImage") != null ||((List<AttachVO>) channelAllInfo.get("chOwnerImage")).size() != 0) {
			List<AttachVO> chOwnerImage = (List<AttachVO>) channelAllInfo.get("chOwnerImage");
			feedsMap.put("ownerImage", chOwnerImage);
		}
		
		feedsMap.put("channel", chContentAndImage);
		
		// Map: feeds, attaches(피드 이미지), channel(채널정보,(back이미지)), (ownerImage)
		model.addAttribute("channelMap", feedsMap);
	}
	
	@GetMapping("/myChannel") //채널정보 -> 세션
	public void getMyChannel(HttpSession session, Model model) {
		UsersVO vo = (UsersVO) session.getAttribute("login");
		String channelOwner = vo.getChannelVO().getChannelOwner();
		
		Map<String,Object> map = service.getAllFeeds(channelOwner);
		log.info("@@@getMyChannelCtrl: "+map);
		
		// feeds, attaches
		model.addAttribute("feedsMap",map);
	}
	
	@GetMapping("/getList/{userId}")//ajax컨트롤러
	@ResponseBody
	public Map<String,Object> getList(@PathVariable("userId") String userId){
		//get은 channelName List는 null
		log.info("ASDASDADADASDSADASDAZ");
		String channelName = null;
		Map<String,Object> channelAllInfo = service.getChannelAndList(channelName, userId);
		
		String[] followList = service.getFollowList(userId);
		channelAllInfo.put("followList", followList);
		
		// Map: chContentAndImage, (chOwnerImage), followList
		return channelAllInfo;
	}
	
//	@GetMapping("/getFollowList/{userId}")
//	public 
	
	@GetMapping("/getChannelImage/{nameType}/{name}")//ajax -> mychannel
	@ResponseBody
	public AttachVO getChannelImage(@PathVariable("nameType") String nameType
								   ,@PathVariable("name") String name) {
		//attachMapper 재활용으로 List로 받아왔지만 무조건 0 아니면 1
		List<AttachVO> list = service.getChannelImagePath(nameType, name);
		if(list == null || list.size() == 0) {
			return new AttachVO();
		}
		AttachVO result = list.get(0);
		
		return result;
	}
	
	@GetMapping(value="/channelExistenceChk/{userId}", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public int channelExistenceChk(@PathVariable("userId") String userId) {
		
		return service.getChannelCountById(userId);
	}
	
	
	@GetMapping("/followCheck/{channelName}/{userId}")
	@ResponseBody
	public int followCheck(@PathVariable("channelName") String channelName
			              ,@PathVariable("userId") String userId) {
		
		return service.getWhetherFollow(channelName, userId);
	}
	
	
	@PostMapping("/registerChannel")
	public String registerChannel(@RequestParam("channelName") String channelName
			                     ,@RequestParam("channelOwner") String channelOwner
			                     ,HttpSession session) {
		
		service.registerChannel(channelName, channelOwner);
		//바로 세션에 넣어주기
		ChannelVO vo = new ChannelVO();
		vo.setChannelName(channelName);
		vo.setChannelOwner(channelOwner);
		vo.setFollowNum(0);
		
		UsersVO users = (UsersVO) session.getAttribute("login");
		users.setChannelVO(vo);
	
		
		return "redirect:/channel/channelList";
	}
	
	@PostMapping("/registerFeed")
	public String registerFeed(@RequestPart(value="files", required=false) MultipartFile[] files, FeedVO vo) throws RuntimeException, IOException {
		
		log.info("@@@@register: "+vo);
		
		service.registerFeed(files, vo);
		
		return "redirect:/channel/myChannel";
	}
	
	@PostMapping("/follow/{channelName}/{userId}/{followUnfollow}")
	public ResponseEntity<?> follow(@PathVariable("channelName") String channelName
			          ,@PathVariable("userId") String userId
			          ,@PathVariable("followUnfollow") String followUnfollow) {
		log.info(channelName);
		log.info(userId);
		log.info(followUnfollow);
		service.modifyFollow(channelName, userId, followUnfollow);
		
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
}
