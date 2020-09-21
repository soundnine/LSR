package com.portfolio.controller;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.portfolio.domain.FeedVO;
import com.portfolio.domain.FreeBoardVO;
import com.portfolio.domain.ReplyVO;
import com.portfolio.service.ReplyService;

import lombok.extern.log4j.Log4j;

@Log4j
@RequestMapping("/replies")
@Controller
public class ReplyAjaxController {
	@Autowired
	ReplyService service;
	
	@GetMapping(value="/getList/{type}/{boardIdx}/{page}", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public Map<String,Object> getReplyList(@PathVariable("type") String type
														,@PathVariable("boardIdx") int boardIdx
														,@PathVariable("page") int page){
	
		log.info("@@@@getReplyList :"+type);
		log.info("@@@@getReplyList :"+boardIdx);
		log.info("@@@@getReplyList :"+page);
		
		Map<String,Object> replyListAndCount = service.getReplyList(type, boardIdx, page);
		
		return replyListAndCount;
		
	}
	
	@GetMapping("/get/{replyIdx}")
	@ResponseBody
	public ReplyVO getReply(@PathVariable("replyIdx") int replyIdx){
		
		ReplyVO reply = service.getReply(replyIdx);
		
		return reply;
		
	}
	
	@PostMapping(value="/register", consumes="application/json")
	public ResponseEntity<String> registerNewReply(@RequestBody ReplyVO vo){
		
		log.info("@@@@registerNewReply :"+vo);
		service.registerReply(vo);
		
		
		return new ResponseEntity<>("success", HttpStatus.OK);
		
	}
	
	@PostMapping(value="/modify/{replyIdx}", consumes="application/json")
	public ResponseEntity<String> modifyReply(@RequestBody String replyContent
											 ,@PathVariable("replyIdx") int replyIdx){
		
		log.info("@@@@modifyReply: "+replyContent);
		
		//lang3
		replyContent = StringUtils.removeStart(replyContent, "\"");
		replyContent = StringUtils.removeEnd(replyContent, "\"");
		log.info("after delete quote: "+replyContent);
		
		service.modifyReply(replyContent, replyIdx);
		
		return new ResponseEntity<>("success", HttpStatus.OK);
		
	}
	
	@PostMapping(value="/remove/{replyIdx}")
	public ResponseEntity<String> removeReply(@PathVariable("replyIdx") int replyIdx){
		
		service.removeReply(replyIdx);
		
		return new ResponseEntity<>("success", HttpStatus.OK);
		
	}
	
}
