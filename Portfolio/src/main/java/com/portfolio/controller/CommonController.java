package com.portfolio.controller;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.portfolio.domain.AttachVO;
import com.portfolio.domain.FreeBoardVO;
import com.portfolio.domain.UsersVO;
import com.portfolio.service.AttachService;
import com.portfolio.service.CommonService;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class CommonController {
	@Autowired
	CommonService service;
	
	
	@GetMapping(value="/getPopularBoards",produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public List<FreeBoardVO> getPopularBoards(){
		return service.getPopularBoards();
	}
	
	@GetMapping("/checkLikeUser/{accessId}/{type}/{idx}")
	public ResponseEntity<Integer> checkLikeUser(@PathVariable("accessId") String accessId
												,@PathVariable("type") String type
												,@PathVariable("idx") int idx){

		int result = service.checkLikeUser(accessId, type, idx);
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@GetMapping(value="/checkLikeUserAllFeeds/{accessId}", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public int[] checkLikeUserAllFeeds(@PathVariable("accessId") String accessId) {
		int[] likeIdx = service.checkLikeUserAllFeeds(accessId);
		return likeIdx;
	}
	
	@GetMapping(value="/getNewFeeds/{userId}/{page}", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public List<Map<String,Object>> getMainNewFeeds(@PathVariable("userId") String userId
			                                       ,@PathVariable("page") int page){
		List<Map<String,Object>> newFeedList = service.getNewFeeds(userId, page);
		//Map: CHANNELNAME, CHANNELOWNER, IDX, CONTENT, UPDATEDATE, (FEED_UPLOADPATH, FEED_UUID, FEED_FILENAME),(CH_UPLOADPATH,CH_UUID,CH_FILENAME)
		return newFeedList;
	}
	
	@GetMapping("/getNewFeedsCount/{userId}")
	@ResponseBody
	public int getNewFeedsCount(@PathVariable("userId") String userId) {
		
		return service.getNewFeedsCount(userId);
	}
	
	
	@PostMapping("/likes/{plusMinus}/{accessId}/{type}/{idx}")
	public ResponseEntity<String> modifyLikes(@PathVariable("plusMinus") String plusMinus
											 ,@PathVariable("accessId") String accessId
											 ,@PathVariable("type") String type
											 ,@PathVariable("idx") int idx){
	
		service.updateLikeCount(plusMinus, accessId, type, idx);
		
		return new ResponseEntity<>("success", HttpStatus.OK);
		
	}
	
	@GetMapping("/showImage")
	@ResponseBody
	public ResponseEntity<byte[]> showImage(String pathName) {
		log.info("@@@@showImage: "+pathName);
		String path = "C:" + File.separator + "UploadedFilesRoot" + File.separator + pathName;
		
		File file = new File(path);
		
		ResponseEntity<byte[]> image = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			image = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return image;
	}
	
	@PostMapping("/uploadImage/{nameType}/{name}")
	public ResponseEntity<?> uploadImage(@RequestBody MultipartFile[] profileImage
						                ,@PathVariable("nameType") String nameType
						                ,@PathVariable("name") String name
						                ,HttpSession session) throws RuntimeException, IOException {
		//유저와 채널은 null 아니면 1
		List<AttachVO> lists = service.uploadImage(profileImage, nameType, name);
		log.info("@@@@"+lists);
		AttachVO attachVO = lists.get(0);
		log.info("@@@@VO@@@@"+attachVO);
		String uploadPath = URLEncoder.encode(attachVO.getUploadPath(), "UTF-8");
		String uuid = attachVO.getUuid();
		String fileName = attachVO.getFileName();
		
		//업로드 후 바로 세션에서 사용할 수 있도록. 채널 이미지 업로드 시 제외. 새로 생성한 아이디는 세션 vo의 attachVO가 null.
		if(attachVO.getUserId() != null && attachVO.getChannelName() == null) {
		UsersVO vo = (UsersVO) session.getAttribute("login");
		
		//새로 만든 아이디 attachVO null 처리
		if(vo.getAttachVO() == null) {
			AttachVO newVO = new AttachVO();
			vo.setAttachVO(newVO);
		}
		
			vo.getAttachVO().setUploadPath(uploadPath);
			vo.getAttachVO().setUuid(uuid);
			vo.getAttachVO().setFileName(fileName);
		
		}
		
		return new ResponseEntity<>(HttpStatus.OK);
		
	}
	
}
