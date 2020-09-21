package com.portfolio.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.portfolio.domain.AttachVO;
import com.portfolio.domain.ChannelVO;
import com.portfolio.domain.FeedVO;
import com.portfolio.domain.UsersVO;
import com.portfolio.persistence.IChannelMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class ChannelServiceImpl implements ChannelService {
	@Autowired
	IChannelMapper mapper;
	@Autowired
	AttachService service;
	
	@Override
	public Map<String,Object> getChannelAndList(String channelName, String userId) {
		Map<String,Object> channelAllInfo = new HashMap<>();
		List<ChannelVO> chCopyTarget = mapper.getChannelAndList(channelName);
		List<ChannelVO> chContentAndImage = new ArrayList<>();
		//자기 채널 목록에서 제외
		if(chCopyTarget.size() != 0) {
			for(ChannelVO vo : chCopyTarget) {
				if(!vo.getChannelOwner().equals(userId)) {
					chContentAndImage.add(vo);
				}
			}
		}
		//단일 getChannel 프로필 이미지 주입
		if(chContentAndImage.size() == 1) { 
			String name = chContentAndImage.get(0).getChannelOwner();
			List<AttachVO> chOwnerImage = service.getImagePathForUsersAndCh(UsersVO.type, name);
			channelAllInfo.put("chOwnerImage", chOwnerImage);
		}
		
		log.warn(chContentAndImage);
		channelAllInfo.put("chContentAndImage", chContentAndImage);
		
		return channelAllInfo;
	}

	@Override
	public List<AttachVO> getChannelImagePath(String nameType, String name) {
		
		return service.getImagePathForUsersAndCh(nameType, name);
	}
	
	@Override //채널 오너 소속 모든 피드 + 첨부파일 있는 경우 첨부파일
	public Map<String,Object> getAllFeeds(String channelOwner){
		List<FeedVO> allFeeds = mapper.getAllFeeds(channelOwner);
		
		//디비 첨부파일 확인용
		List<Integer> idxChk = new ArrayList<Integer>();
		
		for(FeedVO feed : allFeeds) {
			int idx = feed.getIdx();
			idxChk.add(idx);
		}
		
		List<AttachVO> allAttaches = service.getAllFeedAttachList(idxChk);
		//화면에서 c태그 url로 해결.
		//꺼내서 인코딩해서 다시 넣기.
//		List<AttachVO> allAttachesEncoded = new ArrayList<>();
//		for(AttachVO attach : allAttaches) {
//			
//			String uploadPath = URLEncoder.encode(attach.getUploadPath(),"UTF-8");
//			String uuid = URLEncoder.encode(attach.getUuid(),"UTF-8");
//			String fileName = URLEncoder.encode(attach.getFileName(),"UTF-8");
//			attach.setUploadPath(uploadPath);
//			attach.setUuid(uuid);
//			attach.setFileName(fileName);
//			
//			allAttachesEncoded.add(attach);
//		}
		
		Map<String,Object> map = new HashMap<>();
		map.put("feeds", allFeeds);
		map.put("attaches", allAttaches);
		
		return map;
	}
	
	@Override
	public int getChannelCountById(String userId) {
		return mapper.getChannelCountById(userId);
	}
	
	@Override
	public int getWhetherFollow(String channelName, String userId) {
		int result = mapper.getWhetherFollow(channelName, userId);
		return result;
	}
	
	@Override
	public String[] getFollowList(String userId) {
		return mapper.getFollowList(userId);
	}
	
	@Transactional(rollbackFor=RuntimeException.class)
	@Override
	public void registerChannel(String channelName, String channelOwner) throws RuntimeException {
		int check = mapper.getChannelCountById(channelOwner);
		
		if(check > 0) {
			return;
		} else {
			mapper.insertChannel(channelName, channelOwner);
		}
	}
	
	@Transactional(rollbackFor= {RuntimeException.class, IOException.class})
	@Override
	public void registerFeed(MultipartFile[] files, FeedVO vo) throws RuntimeException, IOException {
		int existChk = 0;
		int sizeChk = 0;
		
		//NPE 예외처리
		if(files != null) {
		List<MultipartFile> existingFiles = new ArrayList<>();
		for(int i = 0; i<files.length; i++) {
			boolean exist = files[i].isEmpty();
			long size = files[i].getSize();
			if(exist == false) {
				existChk = existChk + 1; //파일 수 세기
			}
			if(size > 0) {
				sizeChk = sizeChk + 1; //사이즈로도 한번 더 세보기 대입은 이값으로.
				existingFiles.add(files[i]);
			}
			files = existingFiles.toArray(new MultipartFile[0]);
			log.warn("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:"+files);
		 }
	    } 
			log.warn("@@@@@@@:"+existChk);
			log.warn("@@@@@@@:"+sizeChk);
			
			if (existChk == 0 || sizeChk == 0) { // 파일 존재 여부 
				mapper.insertFeed(vo);

			} else if(existChk > 0 && sizeChk > 0){
				mapper.insertFeed(vo);
				service.uploadAttach(files, FeedVO.type, vo.getIdx());
			}
	}
	
	@Transactional(rollbackFor= {RuntimeException.class})
	@Override
	public void modifyFollow(String channelName, String userId, String followUnfollow) throws RuntimeException {
		
			if(followUnfollow.equals("follow")) {
				mapper.insertFollow(channelName, userId);
				mapper.updateFollowCount(channelName, followUnfollow);
				
			} else if(followUnfollow.equals("unFollow")) {
				mapper.deleteFollow(channelName, userId);
				mapper.updateFollowCount(channelName, followUnfollow);
			}
	}





}
