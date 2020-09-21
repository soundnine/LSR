package com.portfolio.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.portfolio.domain.AttachVO;
import com.portfolio.domain.FreeBoardVO;
import com.portfolio.persistence.ICommonMapper;

@Service
public class CommonServiceImpl implements CommonService {
	@Autowired
	ICommonMapper mapper;
	@Autowired
	AttachService service;
	
	@Override
	public List<FreeBoardVO> getPopularBoards() {
		return mapper.getPopularBoards();
	}
	
	@Override
	public List<Map<String, Object>> getNewFeeds(String userId, int page) {
		List<Map<String,Object>> newFeedList = mapper.getNewFeeds(userId, page);

//ATTACH 서비스 레이어의 서비스를 재활용하여 조합하려 했으나 리턴타입과 파라미터를 맞춰주기 위해 리스트안에 맵을 꺼내고 FOR문을 돌리고 또 돌리고 다시 리스트안에 리스트를 넣고 그것을 맵안에 넣는 등 뭔가 복잡하게 변하고 화면단에서도 쓰기 힘들 것 같아서 테이블 4개를 조인시켜서 한번에 가져왔다.
//		List<Integer> idxList =  new ArrayList<>();//서비스 파라미터 삽입
//		List<String> chNameList = new ArrayList<>();//서비스 파라미터 삽입
//		
//		for(Map<String,Object> map : mapList) {
//			Integer idx = (Integer) map.get("IDX");
//			idxList.add(idx);
//			String channelName = (String) map.get("CHANNELNAME");
//			chNameList.add(channelName);
//		}
//		List<AttachVO> feedImages = service.getAllFeedAttachList(idxList);
//		
//		//서비스 레이어들이 너무 단단해진 느낌 수정에 대비해서 list로 만들었는데 음........
//		List<List<AttachVO>> channelImageList = new ArrayList<>();
//		
//		for(String name : chNameList) {
//		List<AttachVO> channelImage = service.getImagePathForUsersAndCh(ChannelVO.type, name);
//		channelImageList.add(channelImage);
//		}
		return newFeedList;
		
//		return; 
	}
	
	@Override
	public int getNewFeedsCount(String userId) {
		return mapper.getNewFeedsCount(userId);
	}
	
	@Override
	public List<AttachVO> uploadImage(MultipartFile[] files, String nameType, String name) throws RuntimeException, IOException {
		return service.uploadImage(files, nameType, name);
	}
	
	@Override
	public int checkLikeUser(String accessId, String type, int idx) {
		
		return mapper.getLikeUserCount(accessId, type, idx) ;
	}

	@Override
	public int[] checkLikeUserAllFeeds(String accessId) {
		
		return mapper.getAllIdxLikeFeeds(accessId);
	}
	
	@Override
	public void updateLikeCount(String plusMinus, String accessId, String type, int idx) {
		mapper.updateLikeCount(plusMinus, accessId, type, idx);
	}








}
