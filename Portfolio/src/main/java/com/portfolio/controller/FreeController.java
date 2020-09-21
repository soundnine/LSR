package com.portfolio.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;

import com.portfolio.domain.AttachVO;
import com.portfolio.domain.FreeBoardVO;
import com.portfolio.domain.UsersVO;
import com.portfolio.service.FreeService;

import lombok.extern.log4j.Log4j;

@Log4j
@RequestMapping("/free")
@Controller
public class FreeController {
	@Autowired
	FreeService service;
	
	@GetMapping("/freeBoardList")
	public void getfreeBoardList(@RequestParam(value="page", defaultValue="1", required=false) int page
								,@RequestParam(value="type", defaultValue="T", required=false) String type
								,@RequestParam(value="keyword", defaultValue="",required=false) String keyword
								,Model model) {
		
		int total = service.getTotalCount(type,keyword);
		List<FreeBoardVO> list = service.getFreeBoardList(page, type, keyword);
		
		model.addAttribute("page", page);
		model.addAttribute("type", type);
		model.addAttribute("keyword", keyword);
		model.addAttribute("total", total);
		model.addAttribute("list", list);
	}
	
	@GetMapping("/getFreeBoard") //리플 -> ajax
	public ModelAndView getFreeBoard(@RequestParam("idx") int idx
									,@RequestParam(value="page", defaultValue="1", required=false) int page
									,@RequestParam(value="type", defaultValue="T", required=false) String type
									,@RequestParam(value="keyword", defaultValue="",required=false) String keyword
									,ModelAndView modelAndView
									//,RedirectAttributes rttr
									,HttpServletRequest request
									,HttpServletResponse response) {
		
		Map<String,Object> map = service.getFreeBoard(idx);
		FreeBoardVO vo = (FreeBoardVO) map.get("board");
		List<AttachVO> attach = (List<AttachVO>) map.get("attach");
		
		//인터셉터 변경
//		HttpSession session = request.getSession();
//		UsersVO sessionVO = (UsersVO)session.getAttribute("login");
//		String accessId = sessionVO.getUserId();
//		String lockingWriter = vo.getWriter();
//		
//		//글 잠금 여부. get요청시 request.getsession 세션아이디 받아서 vo.getwriter와 비교 락킹이 1이고 아이디가 서로 같지않다면 경우만 check, 나머지 경우는 free access
//		if(vo.getLocking()==1&&!lockingWriter.equals(accessId)) {
//			rttr.addAttribute("idx", idx);
//			rttr.addAttribute("page", page);
//			rttr.addAttribute("type", type);
//			rttr.addAttribute("keyword", keyword);
//			return "redirect:/free/checkBoardPw";
		//안 잠겼다면,
	
			//조회수 증가를 위해 쿠키 체크부터.
			Cookie cookies[] = request.getCookies();
			
			Map<String,String> cookieMap = new HashMap<String,String>();
			if(request.getCookies() != null) {
				for(int i = 0; i<cookies.length; i++) {
					cookieMap.put(cookies[i].getName(),cookies[i].getValue());
				}
			}
			
			String existingCountCookie = cookieMap.get("countChk");
			String newCountCookie = "|" + idx;
			
			//현재 게시물에 관한 쿠키가 있는지.
			int cookieChk = StringUtils.indexOfIgnoreCase(existingCountCookie, newCountCookie);
			if(cookieChk == -1) {
				//게시물에 관한 쿠키가 없다면 만들고, 
				Cookie cookie = new Cookie("countChk", existingCountCookie+newCountCookie);
				cookie.setMaxAge(1000*60*60);
				response.addCookie(cookie);
				
				//조회수 업데이트 후 상세 화면 뿌리기.
				int resultCount = service.updateAndGetCount(idx);
				log.info(resultCount);
				vo.setCounts(resultCount);
			} // 쿠키 있으면 조회수 업데이트 안함 기존 VO에 set되어 있는 counts 그대로.
			
			modelAndView.setViewName("/free/getFreeBoard");
			modelAndView.addObject("vo", vo);
			modelAndView.addObject("attach", attach);
			modelAndView.addObject("page", page);
			modelAndView.addObject("type", type);
			modelAndView.addObject("keyword", keyword);
			return modelAndView;
			
//			model.addAttribute("vo", vo);
//			model.addAttribute("attach", attach);
//			model.addAttribute("page", page);
//			model.addAttribute("type", type);
//			model.addAttribute("keyword", keyword);
		}
	
	
	@GetMapping("/checkBoardPw")
	public void checkBoardPwGET(@RequestParam("idx") int idx
							   ,@RequestParam(value="warn" , required=false) String warn
							   ,@RequestParam(value="page", defaultValue="1", required=false) int page
							   ,@RequestParam(value="type", defaultValue="T", required=false) String type
							   ,@RequestParam(value="keyword", defaultValue="",required=false) String keyword
							   ,Model model
							   ,RedirectAttributes rttr) {
		
		model.addAttribute("idx", idx);
		model.addAttribute("page", page);
		model.addAttribute("type", type);
		model.addAttribute("keyword", keyword);

		rttr.addFlashAttribute("warn", warn);
	}
	
	
	@GetMapping("/registerFreeBoard")
	public void registerFreeBoardGET(@RequestParam(value="page", defaultValue="1", required=false) int page
								    ,@RequestParam(value="type", defaultValue="T", required=false) String type
								    ,@RequestParam(value="keyword", defaultValue="",required=false) String keyword
								    ,Model model) { 
		
		Date today = new Date();
		
		model.addAttribute("page", page);
		model.addAttribute("type", type);
		model.addAttribute("keyword", keyword);
		model.addAttribute("today", today);
	}
	
	@GetMapping("/reBoard")
	public void reBoardGET(@RequestParam("idx") int idx
					      ,@RequestParam(value="page", defaultValue="1", required=false) int page
					      ,@RequestParam(value="type", defaultValue="T", required=false) String type
					      ,@RequestParam(value="keyword", defaultValue="",required=false) String keyword
					      ,Model model) {
		
		String title = service.getTitle(idx);
		Date today = new Date();
		
		model.addAttribute("idx", idx);
		model.addAttribute("title", title);
		model.addAttribute("page", page);
		model.addAttribute("type", type);
		model.addAttribute("keyword", keyword);
		model.addAttribute("today", today);
	}
	
	@GetMapping("/modifyFreeBoard") //리플x
	public String modifyFreeBoardGET(@RequestParam("idx") int idx
								    ,@RequestParam(value="page", defaultValue="1", required=false) int page
								    ,@RequestParam(value="type", defaultValue="T", required=false) String type
								    ,@RequestParam(value="keyword", defaultValue="",required=false) String keyword
								    ,HttpServletRequest request
								    ,Model model) {
		
		Map<String, Object> map = service.getFreeBoard(idx);
		FreeBoardVO vo = (FreeBoardVO) map.get("board");
		List<AttachVO> attach = (List<AttachVO>) map.get("attach");
		
		//주소창 GET막기
		HttpSession session = request.getSession();
		UsersVO sessionVO = (UsersVO) session.getAttribute("login");
		
		String accessId = sessionVO.getUserId();
		String boardWriter = vo.getWriter();
		
		if(!boardWriter.equals(accessId)) { 
				return "redirect:/free/freeBoardList";
			
		} else {
		model.addAttribute("vo", vo);
		model.addAttribute("attach", attach);
		model.addAttribute("page", page);
		model.addAttribute("type", type);
		model.addAttribute("keyword", keyword);
		return "/free/modifyFreeBoard";
		}
		
	}
	
	@GetMapping(value="/getLikesNum/{boardIdx}", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public int getLikesNum(@PathVariable("boardIdx") int boardIdx) {
		
		int result = service.getLikesCounts(boardIdx);
		
		return result;
		
	}
	
	
	@PostMapping("/registerFreeBoard")
	public String registerFreeBoardPOST(@RequestPart(value="files", required=false) MultipartFile[] files, FreeBoardVO vo) throws Exception{
		
		log.info("@@@@register: "+vo);
		log.info("@@@@@@@@@@@@@@@@@@@@@@@files length"+files.length);
		
		service.registerFreeBoard(files, vo);
		
		return "redirect:/free/freeBoardList";
	}
	
	@PostMapping("/modifyFreeBoard")
	public String modifyFreeBoardPOST(@RequestParam(value="uuid", required=false) String[] uuid
							         ,@RequestPart(value="files", required=false) MultipartFile[] files
								     ,FreeBoardVO vo) throws Exception {
		
		log.info(Arrays.toString(uuid));
		log.info(vo);
		log.info("@@@@@@@@@@@@@@@@@@@@@@@files length"+files.length);
		
		service.modifyFreeBoard(uuid, files, vo);
		
		return "redirect:/free/getFreeBoard?idx="+vo.getIdx();
	}
	
	
	@PostMapping("/removeBoard") //리플 삭제 추가
	public String removeBoard(@RequestParam("idx") int idx) {
		log.info("@@@@removeBoard: "+idx);
		service.removeBoard(idx);
		
		return "redirect:/free/freeBoardList";
	}
	
	@PostMapping("/reBoard")
	public String reBoardPOST(@RequestParam(value="files", required=false) MultipartFile[] files, FreeBoardVO vo) throws Exception {
	
			service.registerFreeBoard(files, vo);
		
		return "redirect:/free/freeBoardList";
	}
	
	// 화면에선 생성되자마자 input type hidden으로 page keyword type idx form 안에 넣고 패스워드와 submit
	@PostMapping("/checkBoardPw")
	public String checkBoardPwPOST(@RequestParam("idx") int idx
							      ,@RequestParam("lockingPassword") String lockingPassword
							      ,@RequestParam(value="page", defaultValue="1", required=false) int page
							      ,@RequestParam(value="type", defaultValue="T", required=false) String type
							      ,@RequestParam(value="keyword", defaultValue="",required=false) String keyword
							      ,RedirectAttributes rttr
							      ,Model model) throws IOException {
							    
		
		Map<String, Object> map = service.getFreeBoard(idx);
		FreeBoardVO vo = (FreeBoardVO) map.get("board");
		List<AttachVO> attach = (List<AttachVO>) map.get("attach");
		
		log.info("@@@@@@checkBoardPw POST: "+vo.getLockingPassword());
		log.info("@@@@@@checkBoardPw POST: "+lockingPassword);
		log.info("equals?"+(vo.getLockingPassword().equals(lockingPassword)));
		
		UriComponentsBuilder ucb = UriComponentsBuilder.fromPath("")
													   .queryParam("idx", idx)
													   .queryParam("page", page)
													   .queryParam("type", type)
													   .queryParam("keyword", keyword);
		
		if(vo.getLockingPassword().equals(lockingPassword)) {
		    String success = "success";
		    rttr.addAttribute(success);
			return "redirect:/free/getFreeBoard" + ucb.toUriString();
		} else {
			
			String warn = "fail";
			rttr.addFlashAttribute("warn", warn);
			
			return "redirect:/free/checkBoardPw" + ucb.toUriString();
		}
			
	}
	
	 
	
}
