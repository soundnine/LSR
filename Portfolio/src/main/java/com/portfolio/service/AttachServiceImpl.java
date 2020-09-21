package com.portfolio.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.portfolio.domain.AttachVO;
import com.portfolio.domain.FeedVO;
import com.portfolio.domain.FreeBoardVO;
import com.portfolio.persistence.IAttachMapper;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Log4j
@Service
public class AttachServiceImpl implements AttachService {
	@Autowired
	IAttachMapper mapper;
	
	@Transactional(rollbackFor= {RuntimeException.class})
	@Override
	public void uploadAttach(MultipartFile[] files, String boardType, int idx) throws RuntimeException,IOException {
		
		File pathObj = pathObjMaker();
		String uploadPath = pathObj.getAbsolutePath().substring(pathObj.getAbsolutePath().indexOf('\\',3)+1);
		
		for (MultipartFile multiFile : files) { // 하나씩 담아서 로컬에 넣고 DB에 넣기.

			String targetFileName = multiFile.getOriginalFilename();
			targetFileName = targetFileName.substring(targetFileName.indexOf('\\',3) + 1);
			String targetFileType = targetFileName.substring(targetFileName.lastIndexOf(".") + 1);
			Long targetSize = multiFile.getSize();
			
			AttachVO vo = attachObjMaker(uploadPath, targetFileName, targetSize, targetFileType);

			if (boardType.equals(FreeBoardVO.type)) {
				vo.setFreeBoardIdx(idx);
			} else if (boardType.equals(FeedVO.type)) {
				vo.setFeedIdx(idx);
			}
			
			File save = new File(pathObj, vo.getUuid() + "_" + vo.getFileName());
			try {
				multiFile.transferTo(save);
			} catch (IOException|RuntimeException e) {
				e.printStackTrace();
				throw e;
			} 
			mapper.insertAttach(vo);
		}
	}
	@Transactional(rollbackFor= {RuntimeException.class, IOException.class})
	@Override //유저랑 채널 이미지용 nameType-> users, channel 화면에서 이미지첨부만.
	public List<AttachVO> uploadImage(MultipartFile[] files, String nameType, String name) throws RuntimeException, IOException {
		File pathObj = pathObjMaker();
		String uploadPath = pathObj.getAbsolutePath().substring(pathObj.getAbsolutePath().indexOf('\\',3)+1);
		
		for (MultipartFile multiFile : files) { // 하나씩 담아서 로컬에 넣고 DB에 넣기.

			String targetFileName = multiFile.getOriginalFilename();
			targetFileName = targetFileName.substring(targetFileName.indexOf('\\',3) + 1);
			String targetFileType = targetFileName.substring(targetFileName.lastIndexOf(".") + 1);
			Long targetSize = multiFile.getSize();
			
			AttachVO vo = attachObjMaker(uploadPath, targetFileName, targetSize, targetFileType);
			log.warn("@@@@uploadImage: "+vo);
			if (nameType.equals("users")) {
				vo.setUserId(name);
			} else if (nameType.equals("channel")) {
				vo.setChannelName(name);
			}
			log.warn("@@@@uploadImage2: "+vo);
			File save = new File(pathObj, vo.getUuid() + "_" + vo.getFileName());
			try {
				multiFile.transferTo(save);
				FileOutputStream thumbnail = new FileOutputStream(new File(pathObj, vo.getUuid() + "_thumb_" + vo.getFileName()));
				Thumbnailator.createThumbnail(multiFile.getInputStream(), thumbnail,240,160);
				thumbnail.close();
			} catch (IOException|RuntimeException e) {
				e.printStackTrace();
				throw e;
			} 
			//로컬지우고 디비지우고 디비 인서트
			List<AttachVO> lists = mapper.getLocalPathsByName(nameType, name);
			
			if(lists == null || lists.size() == 0) {
				mapper.insertAttach(vo);
			} else {
				removeUtil(lists);
				mapper.deleteUserAndChImage(nameType, name);
				mapper.insertAttach(vo);
			}
			
		}
		return mapper.getLocalPathsByName(nameType, name);
	}
	
	@Transactional(rollbackFor= {RuntimeException.class})
	@Override
	public void removeAttachAll(String boardType, int idx) throws RuntimeException {
		mapper.deleteAttachAll(boardType, idx);
	}
	
	@Transactional(rollbackFor= {RuntimeException.class})
	@Override
	public void removeSelectedAttach(List<String> list) throws RuntimeException {
		mapper.deleteSelectedAttach(list);
	}
	
	@Override 
	public List<AttachVO> getAttachList(String boardType, int idx) {
		return mapper.getAttachList(boardType, idx);
	}
	
	@Override
	public int countAttach(String boardType, int idx) {
		return mapper.countAttach(boardType, idx);
	}

	@Override
	public String[] getAllUuid(String boardType, int idx) {
		return mapper.getAllUuid(boardType, idx);
	}
	//로컬파일 삭제.
	@Override
	public void removeLocalFilesByUuids(List<String> list) {
		List<AttachVO> lists = mapper.getLocalPathsByUuids(list);
		log.warn("removeByUuid:"+lists);
		//익셉션 발생 우려
		if(lists == null || lists.size() == 0) {
			return;
		} else {
			removeUtil(lists);
		}
	}
	
	@Override
	public void removeLocalFilesByIdx(String boardType, int idx) {
		List<AttachVO> lists = mapper.getLocalPathsByIdx(boardType, idx);
		log.warn("removeByIdx:"+lists);
		//익셉션 발생 우려
		if(lists == null || lists.size() == 0) {
			return;
		} else {
			removeUtil(lists);
		}
	}
	
	@Override
	public List<AttachVO> getImagePathForUsersAndCh(String nameType, String name) {
		List<AttachVO> lists = mapper.getLocalPathsByName(nameType, name);
		//NPE용 빈 객체 보내기
		if(lists == null || lists.size() == 0) {
			return new ArrayList<AttachVO>();
		}
		return lists;
	}
	
	@Override
	public List<AttachVO> getAllFeedAttachList(List<Integer> list) {
		log.warn("@@@@@@getAllFeedAttachList:"+list);
		
		//foreach 예외처리
		if(list == null || list.size() == 0) {
			Integer empty = 0;
			list.add(empty);
		}
		
		return mapper.getAllFeedAttachList(list);
	}
	
	//재활용
	private File pathObjMaker() {
		
		String root = "C:" + File.separator + "UploadedFilesRoot";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String targetDir = sdf.format(date).replace("-",File.separator);
		
		File targetFilePath = new File(root, targetDir); // root 경로에 저장될 디렉토리 경로 객체 생성.
		
		if (targetFilePath.exists() == false) {
			targetFilePath.mkdirs(); // 경로 없다면 만들기
		}
		
		return targetFilePath;
	}
	
	//재활용
	private AttachVO attachObjMaker(String uploadPath, String fileName, Long size, String type) {
		
		AttachVO vo = new AttachVO();
		UUID uuid = UUID.randomUUID();
		
		vo.setUuid(uuid.toString());
		vo.setUploadPath(uploadPath);
		vo.setFileName(fileName);
		vo.setFileSize(size);
		vo.setFileType(type);
		
		return vo;
		}
	
	//재활용
	private void removeUtil(List<AttachVO> lists) {
		
		for(AttachVO vo : lists) {
			String root = "C:" + File.separator + "UploadedFilesRoot" + File.separator;
			String uploadPath = vo.getUploadPath();
			String uuid = vo.getUuid();
			String fileName = vo.getFileName();
			String targetPath = root + uploadPath + File.separator + uuid + "_" + fileName;
			String targetThumbnail = root + uploadPath + File.separator + uuid + "_thumb_" + fileName;
			
			File file = new File(targetPath);
			file.delete();
			
			File fileThumbnail = new File(targetThumbnail);
			fileThumbnail.delete();
		}
	}


	
}
