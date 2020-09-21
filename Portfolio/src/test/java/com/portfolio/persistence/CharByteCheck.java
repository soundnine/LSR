package com.portfolio.persistence;

import org.junit.Test;

public class CharByteCheck {
	
	@Test
	public void byteChk() { //특문 숫자 영어 1바이트  한글 자음모음 완성글자 모두 3바이트 일본어 3바이트 한자 3바이트
		String target = "中";
		String target2 = "$";
		String target3 = "ㅎ";
		String target4 = "ㅏ";
		String target5 = "ナ";
		byte[] result = target5.getBytes();
		
		System.out.println(result.length);
	
	}
}
