package com.portfolio.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.portfolio.domain.AttachVO;
import com.portfolio.domain.FreeBoardVO;
import com.portfolio.persistence.IFreeMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class FreeServiceImpl implements FreeService {
	@Autowired
	IFreeMapper mapper;
	@Autowired
	AttachService service;
	
	@Override
	public List<FreeBoardVO> getFreeBoardList(int page, String type, String keyword) {
		return mapper.getFreeBoardList(page, type, keyword);
	}
	
	@Transactional(rollbackFor= {RuntimeException.class})
	@Override //게시물, 댓글은 ajax, 첨부파일   type-> 첨부파일 또는 댓글 테이블에서 게시판 테이블에 맞게 선택해서 가져오기
	public Map<String, Object> getFreeBoard(int idx) throws RuntimeException{
		 
		List<AttachVO> attach = service.getAttachList(FreeBoardVO.type, idx);
		FreeBoardVO board = mapper.getFreeBoard(idx);
		 
		 Map<String, Object> map = new HashMap<>();
		 map.put("board",board);
		 if(attach != null) {
		 map.put("attach",attach);
		 }
		 
		return map;
	}
	
	@Transactional(rollbackFor= {RuntimeException.class, IOException.class})
	@Override
	public void registerFreeBoard(MultipartFile[] files, FreeBoardVO vo) throws RuntimeException, IOException{
		int existChk = 0;
		int sizeChk = 0;
		//NPE 예외처리
		if(files != null) {
		List<MultipartFile> existingFiles = new ArrayList<>();
		//화면에서 input type=file은 파일이 없어도 빈객체(true)와 file length 기본 1로 넘어오기 때문에 그냥 null이나 0으로 if문 걸면 작동이 안된다.
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
		}
			files = existingFiles.toArray(new MultipartFile[0]);
		}
			log.warn("@@@@@@@@@@@registerFreeBoard exist: "+existChk);
			log.warn("@@@@@@@@@@@registerFreeBoard exist: "+sizeChk);
			
			if (existChk == 0 || sizeChk == 0) { // 파일 존재 여부 
				mapper.insert(vo);

			} else if(existChk > 0 && sizeChk > 0){
				mapper.insert(vo);
				service.uploadAttach(files, FreeBoardVO.type, vo.getIdx());
			}
		
	}
	
	@Transactional(rollbackFor = {RuntimeException.class, IOException.class})
	@Override // db 첨부파일과 넣어줄 파일 비교하여 업데이트
	public void modifyFreeBoard(String[] uuid, MultipartFile[] files, FreeBoardVO vo)
			throws RuntimeException, IOException {
		
		int idx = vo.getIdx();
		int inputFilesNum;
		boolean uuidChk = false;
		int existChk = 0;
		int sizeChk = 0;
		
		if(files != null) {
		List<MultipartFile> existingFiles = new ArrayList<>(); //빈 input 들어오는 것 빼기 위해 밑에서 확인하고 담기
		
		for (int i = 0; i<files.length; i++) {
			boolean exist = files[i].isEmpty();
			long size = files[i].getSize();
			if (exist == false) {
				existChk = existChk + 1; // 파일 수 세기
			}
			if (size > 0) {
				sizeChk = sizeChk + 1; // 사이즈로 한번 더 세보기
				existingFiles.add(files[i]);
			}
		}
			files = existingFiles.toArray(new MultipartFile[0]);
		}
		
		if (uuid == null) { // 기존 목록에서 수정할 uuid. 기존에 첨부파일이 없거나 사용자가 다 지우는 방향으로 결정한 경우 트루
			uuidChk = true;
		}

		if (existChk == 0 || sizeChk == 0) { // 파일없다면 수정할 파일 없음.
			inputFilesNum = 0;
		} else {
			inputFilesNum = sizeChk; // 있다면 센 수랑 맞춰줌.
		}

		
		// 애초에 파일이 없었거나 사용자가 기존 파일을 모두 지우는 방향으로 선택한 경우. 로컬부터 지움.
		if (uuidChk) {
			service.removeLocalFilesByIdx(FreeBoardVO.type, idx);
			service.removeAttachAll(FreeBoardVO.type, idx);
			if (inputFilesNum <= 0) { // 파일 첨부도 안함
				mapper.update(vo);
				return;
			} else if (inputFilesNum > 0) { // 파일 첨부는 함. 인풋태그를 추가해도 파일을 아예 안넣으면 조건문을 통과하지 못하지만
											//	인풋태그 1개 또는 2개를 추가하고
											//	파일등록은 그보다 적게한다면 조건문을 통과하는 null을 넣어버릴 수 있음 -> existingFiles List로 해결.
				service.uploadAttach(files, FreeBoardVO.type, idx);
				mapper.update(vo);
				return;
			}

		} else {

			// 화면에서 넘어온 값 0이 아니라면 List로.
			List<String> uuidList = new ArrayList<>(Arrays.asList(uuid));

			// DB에서 뽑아온 값. 위 값이 0이 아니라면 무조건 존재.
			String[] existUuid = service.getAllUuid(FreeBoardVO.type, idx);
			List<String> existUuidList = new ArrayList<>(Arrays.asList(existUuid));

			// 사용자가 기존 파일 수정을 원하지 않는 경우. 둘 다 0인 경우는 우선 위에서 거르니 1/2/3 케이스
			if (uuidList.size() == existUuidList.size()) {
				if (inputFilesNum <= 0) {
					mapper.update(vo);
					return;
				} else if (inputFilesNum > 0) {
					service.uploadAttach(files, FreeBoardVO.type, idx);
					mapper.update(vo);
					return;
				}
			}
			// 지금까지 거른 케이스 0-0,1-1,2-2,3-3,0-1,0-2,0-3 //나머지는 1-2,1-3,2-1,2-3,3-1,3-2인데 앞이 더
			// 클순 없으니 1-2,1-3,2-3밖에 안남음.
			// db에서 uuid뽑고 화면에서 넘어온 uuid 겹치는 것 삭제. 그 후 남은 것 db로 넘겨서 삭제할 것 삭제하면 된다. UUID는
			// PRIMARY KEY라 보드타입 필요X
			else {
				existUuidList.removeAll(uuidList);//어레이리스트 프로퍼티 조정
				service.removeLocalFilesByUuids(existUuidList); // 로컬부터 삭제
				service.removeSelectedAttach(existUuidList);
				if (inputFilesNum <= 0) {
					mapper.update(vo);
					return;
				} else if (inputFilesNum > 0) {
					service.uploadAttach(files, FreeBoardVO.type, idx);
					mapper.update(vo);
					return;
				}
			}
		}
	}

	@Transactional(rollbackFor= {RuntimeException.class,IOException.class})
	@Override //로컬첨부파일 - 디비첨부파일 - 게시판 순
	public void removeBoard(int idx) throws RuntimeException {
		service.removeLocalFilesByIdx(FreeBoardVO.type, idx);
		service.removeAttachAll(FreeBoardVO.type, idx);
		mapper.delete(idx);
	}
	
	@Override //페이징용
	public int getTotalCount(String type, String keyword) {
		return mapper.getTotal(type, keyword);
	}

	@Override //답변 게시판 제목
	public String getTitle(int idx) {
		return mapper.getTitle(idx);
	}

	@Override//조회수 업데이트하고 가져오기 (글 클릭)
	public int updateAndGetCount(int idx) {
			FreeBoardVO vo = new FreeBoardVO();
			vo.setIdx(idx);
			mapper.updateAndGetCount(vo);
			int result = vo.getCounts();
		return result;
	}

	@Override // 좋아요 수 ajax
	public int getLikesCounts(int boardIdx) {
		
		return mapper.getLikesCounts(boardIdx);
	}
	

}
