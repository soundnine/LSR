package com.portfolio.service;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;
import org.junit.Test;

import lombok.extern.log4j.Log4j;


public class FileObjTest {

	
	@Test
	public void test() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date).replace("-",File.separator);
		
		String root = "C:" + File.separator + "UploadedFilesRoot";
		String targetDir = str;
		File targetFilePath = new File(root, targetDir);
		
		String test = targetFilePath.getPath();
		String test2 = targetFilePath.getAbsolutePath();
		String last1 = test.substring(test.lastIndexOf("\\")+1);
		String last2 = test2.substring(test2.lastIndexOf("\\")+1);
		String dd = targetFilePath.getAbsolutePath().substring(targetFilePath.getAbsolutePath().lastIndexOf("\\")+1);
		String index = test2.substring(test2.indexOf('\\',3)+1);
//		String utilIndex = StringUtils.removeStart(index, "\\");
		System.out.println(str);
		System.out.println(test);
		System.out.println(test2);
		System.out.println(last1);
		System.out.println(last2);
		System.out.println(dd);
		System.out.println(index);
//		System.out.println(utilIndex);
	}
}
