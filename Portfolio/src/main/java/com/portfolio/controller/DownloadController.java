package com.portfolio.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class DownloadController {
	
	@GetMapping(value="/download", produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public ResponseEntity<Resource> download(@RequestHeader("User-Agent") String userAgent, String fileName){
		String root = "C:"+File.separator+"UploadedFilesRoot"+File.separator; //UploadedFilesRoot밑에 경로 구축.
		Resource resource = new FileSystemResource(root + fileName); 
		
		if(resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		String existFileName = resource.getFilename(); //경로 제외 파일이름
		String OriginalName = existFileName.substring(existFileName.indexOf(""
				+ "_")+1); //순수 이름
		
		HttpHeaders headers = new HttpHeaders();
		String download = "";
		try {
			if(userAgent.indexOf("MSIE")>-1 || userAgent.indexOf("Trident")>-1) {
			//헤더에 MSIE나 Trident(IE11)가 있다면 IE
				download = URLEncoder.encode(OriginalName,"UTF-8").replaceAll("\\+"," ");
			} else {
				download = new String(OriginalName.getBytes("UTF-8"),"ISO-8859-1");
			}
				headers.add("Content-Disposition","attachment; filename=" + download);
				} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
}
